export const load = async ({ fetch }): Promise<any> => {
  return {
    shifts: await Promise.resolve([
      {
        id: '0',
        date: 'February 24, 2025',
        time: '11:00am - 2:00pm',
        title: 'Saturday Librarian Shift',
        volunteers: ['Alice', 'Bob']
      },
      {
        id: '1',
        date: 'March 2, 2025',
        time: '4:00pm - 6:00pm',
        title: 'Tuesday Mechanic Shift',
        volunteers: ['Bob', 'Charlie']
      },
      {
        id: '2',
        date: 'March 3, 2025',
        time: '6:00pm - 8:00pm',
        title: 'Wednesday Librarian Shift',
        volunteers: ['Alice']
      }
    ])
  };
};