const { findMember } = require("../../../services/borrowers");
const { fetchJobs, updateJobAssignments } = require("../../../services/jobs/service");

const dateFormatOptions = { year: 'numeric', month: 'long', day: 'numeric' };

const formatTime = (date) => {
  let hours = date.getHours();
  let minutes = date.getMinutes();
  let ampm = hours >= 12 ? 'pm' : 'am';

  hours = hours % 12; hours = hours ? hours : 12;
  minutes = minutes < 10 ? '0' + minutes : minutes; 
  return hours + ':' + minutes + ampm;
};

const getShifts = async ({ email }) => {
  const member = await getMember(email);
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
      enrolled: j.members.some((m) => m.id === member?.id),
      volunteers: j.members.filter((m) => m.id !== member?.id).map((m) => ({
        name: m.name,
        firstName: m.name.split(' ')?.[0],
        keyholder: m.keyholder
      }))
    };
  });
};

const getMember = async (email) => {
  return !!email ? await findMember({ email }) : undefined;
};

const enroll = async (email, shifts) => {
  return await updateJobAssignments(email, shifts);
};

module.exports = { enroll, getShifts };