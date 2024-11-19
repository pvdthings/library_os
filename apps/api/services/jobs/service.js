const { base, Table } = require('../../db');

const jobs = base(Table.Jobs);
const members = base(Table.Borrowers);

const fetchJobs = async () => {
  const records = await jobs.select({ view: 'Future' }).all();

  return await Promise.all(records.map(async (r) => {
    const memberIds = r.get('Members');

    return {
      id: r.id,
      title: r.get('Title'),
      canceled: !!r.get('Canceled'),
      description: r.get('Description'),
      members: await Promise.all(memberIds.map(async (id) => {
        const memberRecord = await members.find(id);

        return {
          name: memberRecord.get('Name')
        };
      })),
      startTime: r.get('Start Time'),
      duration: r.get('Duration')
    };
  }));
};

module.exports = {
  fetchJobs
};