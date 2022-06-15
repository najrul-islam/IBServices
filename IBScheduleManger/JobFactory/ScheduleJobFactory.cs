using Quartz;
using Quartz.Spi;

namespace IBScheduleManger.JobFactory
{
    internal class ScheduleJobFactory : IJobFactory
    {
        private readonly IServiceProvider service;
        public ScheduleJobFactory(IServiceProvider serviceProvider)
        {
            service = serviceProvider;
        }
        public IJob NewJob(TriggerFiredBundle bundle, IScheduler scheduler)
        {
            var jobDetail = bundle.JobDetail;
            return (IJob)service.GetService(jobDetail.JobType);
        }

        public void ReturnJob(IJob job)
        {

        }
    }
}
