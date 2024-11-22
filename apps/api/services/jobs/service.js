const { base, Table } = require('../../db');

const jobs = base(Table.Jobs);
const members = base(Table.Borrowers);

const fetchJobs = async () => {
  const records = await jobs.select({ view: 'Future' }).all();

  return await Promise.all(records.map(async (r) => {
    const memberIds = r.get('Members') || [];

    return {
      id: r.id,
      title: r.get('Title'),
      canceled: !!r.get('Canceled'),
      description: r.get('Description'),
      members: await Promise.all(memberIds.map(async (id) => {
        const memberRecord = await members.find(id);

        return {
          id: memberRecord.id,
          name: memberRecord.get('Name'),
          keyholder: !!memberRecord.get('Keyholder')
        };
      })),
      startTime: r.get('Start Time'),
      duration: r.get('Duration')
    };
  }));
};

const updateJobAssignments = async (email, jobs) => {
  const matches = await members.select({
    filterByFormula: `{Email} = '${email}'`
  }).all();

  if (!matches.length) {
    throw new Error('Email provided does not match any member.');
  }

  const memberRecord = matches[0];
  const existingJobs = memberRecord.get('Jobs') || [];
  
  const toAdd = jobs.filter((j) => !j.remove).map((j) => j.id);
  const toRemove = jobs.filter((j) => !!j.remove).map((j) => j.id);

  const updatedJobs = [
    ...toAdd,
    ...existingJobs.filter((j) => toRemove.includes(j.id))
  ];

  await memberRecord.updateFields({
    'Jobs': updatedJobs
  });
};

module.exports = {
  fetchJobs,
  updateJobAssignments
};