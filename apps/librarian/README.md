# Librarian

## About

Librarian is the first app in **Library OS**. It is intended to be used by volunteers or employees of a lending library to record inventory, manage members, and check items in/out.

## Running the app

### Set environment variables

```
SUPABASE_URL
SUPABASE_KEY
```

### Launch in Chrome

```
flutter run -d chrome
```

For a better debugging experience, use the Flutter dev tools in Visual Studio Code.

## The Supabase Migration Checklist

- Repositories
  - Loans
  - Members
  - Inventory
  - Payments
- Actions
  - Extend Active Loans
- DB Automations / Email Notifications
  - New Loan Created
  - Due Date Updated
  - Due Back Reminder
  - Overdue Notice
  - Membership Renewal