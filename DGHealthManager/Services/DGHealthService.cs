using CFEMSDB.DB;
using DGHealthManager.Models;
using Microsoft.Extensions.Configuration;
using Renci.SshNet;

namespace DGHealthManager.Services;

internal interface IDGHealthService
{
    public DGHealthService SettingTimeZone();
    public void Execute();
}
internal class DGHealthService:IDGHealthService
{
    private readonly IConfiguration _config;
    private readonly IBDBContext _db;
    private TimeZoneInfo _tz;
    //private string _dbConnectionString;
    private List<VMDetail> VMDetails;

    public DGHealthService(IConfiguration config, IBDBContext db)
    {
        _config = config;
        _db = db;
    }


    public DGHealthService SettingTimeZone()
    {
        string timezone = _config.GetSection("Timezone").Value;
        //_dbConnectionString = _config.GetConnectionString("DefaultConnection");

        try
        {
            _tz = TimeZoneInfo.FindSystemTimeZoneById(timezone);

        }
        catch (Exception ex)
        {
            Console.WriteLine($"Exception on Setting Timezone: {ex}");
        }

        return this;
    }

    public void Execute()
    {
        try
        {
            //using (var db = new IBDBContext(_dbConnectionString))
            //{
                //VMDetails = (from d in db.TblDgSetups
                //             join v in db.TblDgVmSetups on d.ColDgVmSetupIdFk equals v.ColDgVmSetupId.ToString()
                //             select new VMDetail
                //             {
                //                 VMId = v.ColDgVmId,
                //                 DGId = d.ColDgId,
                //                 MaintenanceCompanyId = d.ColDgMaintenanceCompanyIdFk,
                //                 VMHostAddress = v.ColHostAddress,
                //                 VMUsername = v.ColHostUsername,
                //                 VMStatus = v.ColVmStatus ?? 0
                //             }).ToList();

                VMDetails = (from v in _db.TblDgVmSetups
                             where v.ColIsActive == true
                             select new VMDetail
                             {
                                 VMId = v.ColDgVmId,
                                 DGId = _db.TblDgSetups.Where(i => i.ColDgVmSetupIdFk == v.ColDgVmSetupId.ToString() && i.ColIsActive == true).Select(i => i.ColDgId).FirstOrDefault(),
                                 MaintenanceCompanyId = v.ColDgMaintenanceCompanyIdFk,
                                 VMHostAddress = v.ColHostAddress,
                                 VMUsername = v.ColHostUsername,
                                 VMStatus = v.ColVmStatus.HasValue ? v.ColVmStatus.Value : 0
                             }).ToList();
            //}

            while (true)
            {
                foreach (var vmDetail in VMDetails)
                {
                    //var workingDirectory = Environment.CurrentDirectory;
                    if (File.Exists($"VMPrivateKey/{vmDetail.VMHostAddress}.pem"))
                    {
                        SshClient sshClient;
                        try
                        {
                            sshClient = new SshClient(vmDetail.VMHostAddress, 22, vmDetail.VMUsername, new PrivateKeyFile[] { new PrivateKeyFile($"VMPrivateKey/{vmDetail.VMHostAddress}.pem") });
                            sshClient.Connect();
                            try
                            {
                                SshCommand command = sshClient.CreateCommand("lsb_release -a");
                                string output = command.Execute();

                                if (output.Split("\n")[0].Split(":")[1].Trim().ToLower() == "ubuntu")
                                {
                                    // VM is online
                                    updateVMOnlineStatus(vmDetail.VMId, true);

                                    // VM Running
                                    switch (vmDetail.VMStatus)
                                    {
                                        case 0:
                                            {
                                                // Down VM recovered
                                                int newStatus = UpdateVMStatus(vmDetail.VMId, 2);
                                                if (newStatus == -1)
                                                {
                                                    Console.WriteLine($"Downed VM: {vmDetail.VMId} with Host: {vmDetail.VMHostAddress} not found in IB Database");
                                                }
                                                else
                                                {
                                                    vmDetail.VMStatus = newStatus;
                                                    Console.WriteLine($"Downed VM: {vmDetail.VMId} with Host: {vmDetail.VMHostAddress} recovered and marked as backup");
                                                }

                                            }
                                            break;
                                        case 1:
                                            {
                                                // Active VM running
                                                Console.WriteLine($"VM: {vmDetail.VMId} is running with DG: {vmDetail.DGId} on Host: {vmDetail.VMHostAddress}");
                                            }
                                            break;
                                        case 2:
                                            {
                                                // Backup VM running
                                                Console.WriteLine($"Backup VM: {vmDetail.VMId} with Host: {vmDetail.VMHostAddress} running");
                                            }
                                            break;
                                    }
                                }
                                else
                                {
                                    // VM is offline
                                    updateVMOnlineStatus(vmDetail.VMId, false);

                                    Console.WriteLine($"VM {vmDetail.VMId} with Host: {vmDetail.VMHostAddress} ssh successful but lsb_release -a retruns: {output}");
                                }
                            }
                            catch (Exception ex)
                            {
                                // VM is offline
                                updateVMOnlineStatus(vmDetail.VMId, false);

                                Console.WriteLine($"VM {vmDetail.VMId} with Host: {vmDetail.VMHostAddress} ssh successful but command execution thrown exception: {ex.ToString()}");
                            }

                            sshClient.Disconnect();
                        }
                        catch (Exception)
                        {
                            // VM is offline
                            updateVMOnlineStatus(vmDetail.VMId, false);

                            // SSH cannot connect
                            switch (vmDetail.VMStatus)
                            {
                                case 0:
                                    {
                                        // Down VM didn't recovered
                                        Console.WriteLine($"VM: {vmDetail.VMId} with Host: {vmDetail.VMHostAddress} still down");
                                    }
                                    break;
                                case 1:
                                    {
                                        // Active VM Down
                                        RunBackeupVM(vmDetail);
                                    }
                                    break;
                                case 2:
                                    {
                                        // Backup VM Down
                                        Console.WriteLine($"Backup VM: {vmDetail.VMId} with Host: {vmDetail.VMHostAddress} down");

                                        int newStatus = UpdateVMStatus(vmDetail.VMId, 0);

                                        if (newStatus == -1)
                                        {
                                            vmDetail.VMStatus = 0;
                                            Console.WriteLine($"Backup VM: {vmDetail.VMId} with Host: {vmDetail.VMHostAddress} not found on IB Database");
                                        }
                                        else
                                        {
                                            vmDetail.VMStatus = newStatus;
                                        }
                                    }
                                    break;
                            }
                        }
                    }
                    else
                    {
                        Console.WriteLine($"Private key is missing for VM: {vmDetail.VMId} with host: {vmDetail.VMHostAddress}");
                    }
                }
                Thread.Sleep(10000);
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString());
        }
    }

    private void updateVMOnlineStatus(string VMId, bool status)
    {
        try
        {
            //using (var db = new IBDBContext(_dbConnectionString))
            //{
                var currentVM = _db.TblDgVmSetups.Where(i => i.ColDgVmId == VMId).FirstOrDefault();
                if (currentVM != null)
                {
                    currentVM.ColIsOnline = status;
                    _db.TblDgVmSetups.Update(currentVM);
                    _db.SaveChanges();
                }
            //}
        }
        catch (Exception ex)
        {
            Console.WriteLine($"VM online status update failed with Exception: {ex}");
        }
    }

    private void RunBackeupVM(VMDetail vmDetail)
    {
        //using (var db = new IBDBContext(_dbConnectionString))
        //{
            var downedDG = _db.TblDgSetups.Where(i => i.ColDgId == vmDetail.DGId).FirstOrDefault();
            var downedVM = _db.TblDgVmSetups.Where(i => i.ColDgVmId == vmDetail.VMId).FirstOrDefault();
            var backUpVM = (from v in _db.TblDgVmSetups
                            where
                            v.ColIsActive == true
                            && v.ColVmStatus == 2
                            && v.ColDgMaintenanceCompanyIdFk == vmDetail.MaintenanceCompanyId
                            select v).FirstOrDefault();

            if (backUpVM != null)
            {
                SshClient sshClient;
                try
                {
                    sshClient = new SshClient(backUpVM.ColHostAddress, 22, backUpVM.ColHostUsername, new PrivateKeyFile[] { new PrivateKeyFile($"VMPrivateKey/{backUpVM.ColHostAddress}.pem") });
                    sshClient.Connect();

                    try
                    {
                        // run start DG script with DG Id parameter
                        SshCommand command = sshClient.CreateCommand($"/home/{backUpVM.ColHostUsername}/StartDG.sh -d {downedDG.ColDgId} -v {backUpVM.ColDgVmId}");
                        string output = command.Execute();

                        Console.WriteLine($"Backup VM {backUpVM.ColDgVmId} started with Host: {backUpVM.ColHostAddress} and DG: {downedDG.ColDgId}");

                        downedDG.ColDgVmSetupIdFk = backUpVM.ColDgVmSetupId.ToString();
                        downedVM.ColVmStatus = 0;
                        backUpVM.ColVmStatus = 1;

                        _db.TblDgSetups.Update(downedDG);
                        _db.TblDgVmSetups.Update(downedVM);
                        _db.TblDgVmSetups.Update(backUpVM);

                        _db.SaveChanges();

                        var downedVMDetails = VMDetails.Where(i => i.VMId == vmDetail.VMId).FirstOrDefault();
                        if (downedVMDetails != null)
                        {
                            downedVMDetails.VMStatus = 0;
                        }

                        var backupVmDetails = VMDetails.Where(i => i.VMId == backUpVM.ColDgVmId).FirstOrDefault();
                        if (backupVmDetails != null)
                        {
                            backupVmDetails.VMStatus = 1;
                            backupVmDetails.DGId = vmDetail.DGId;
                        }

                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"VM: {backUpVM.ColDgVmId} with Host: {backUpVM.ColHostAddress} start DG sript failed to run with Exception: {ex}");
                    }

                }
                catch (Exception)
                {
                    Console.WriteLine($"Backup VM: {backUpVM.ColDgVmId} with Host: {backUpVM.ColHostAddress} is not accessible. SSH failed");
                }
            }
            else
            {
                Console.Write($"No Backup VM found on IB Database");
            }
        //}
    }

    private int UpdateVMStatus(string VMId, byte status)
    {
        int newStatus;
        //using (var db = new IBDBContext(_dbConnectionString))
        //{
            var vm = _db.TblDgVmSetups.Where(i => i.ColDgVmId == VMId).FirstOrDefault();
            if (vm != null)
            {
                vm.ColVmStatus = status;

                _db.TblDgVmSetups.Update(vm);
                _db.SaveChanges();

                var updatedStatus = _db.TblDgVmSetups.Where(i => i.ColDgVmId == VMId).Select(i => i.ColVmStatus).FirstOrDefault();
                newStatus = updatedStatus.Value;
            }
            else
            {
                // VM record not found on IB Database
                newStatus = -1;
            }
        //}
        return newStatus;
    }
}
