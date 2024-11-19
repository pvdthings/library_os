const { fetchJobs } = require("../../../services/jobs/service");

const dateFormatOptions = { year: 'numeric', month: 'long', day: 'numeric' };

const formatTime = (date) => {
  let hours = date.getHours();
  let minutes = date.getMinutes();
  let ampm = hours >= 12 ? 'pm' : 'am';

  hours = hours % 12; hours = hours ? hours : 12;
  minutes = minutes < 10 ? '0' + minutes : minutes; 
  return hours + ':' + minutes + ampm;
};

const getShifts = async () => {
  const jobs = await fetchJobs();

  return jobs.map((j) => {
    const date = new Date(j.startTime);
    let endDate = new Date(j.startTime);
    endDate.setSeconds(date.getSeconds() + j.duration);

    return {
      id: j.id,
      title: j.title,
      date: date.toLocaleString('en-US', dateFormatOptions),
      timespan: `${formatTime(date)} - ${formatTime(endDate)}`,
      description: j.description,
      volunteers: j.members.map((m) => ({
        ...m,
        firstName: m.name.split(' ')?.[0]
      }))
    };
  });
};

module.exports = { getShifts };