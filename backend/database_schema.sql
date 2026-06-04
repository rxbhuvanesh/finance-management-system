create table if not exists users (
  id bigserial primary key,
  username varchar(64) unique not null,
  hashed_password varchar(255) not null,
  full_name varchar(128),
  role varchar(32) not null default 'admin',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists customers (
  id bigserial primary key,
  name varchar(120) not null,
  mobile_number varchar(15) not null,
  address text not null,
  aadhaar_number varchar(16) unique not null,
  notes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
create index if not exists idx_customers_name on customers(name);
create index if not exists idx_customers_mobile on customers(mobile_number);

create table if not exists loans (
  id bigserial primary key,
  customer_id bigint not null references customers(id) on delete cascade,
  principal_amount numeric(12,2) not null,
  interest_percentage numeric(5,2) not null,
  emi_duration_months int not null,
  due_day int not null,
  status varchar(32) not null default 'active',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
create index if not exists idx_loans_customer_id on loans(customer_id);

create table if not exists payments (
  id bigserial primary key,
  loan_id bigint not null references loans(id) on delete cascade,
  amount numeric(12,2) not null,
  paid_on varchar(20) not null,
  payment_mode varchar(32) not null default 'cash',
  status varchar(32) not null default 'paid',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
create index if not exists idx_payments_loan_id on payments(loan_id);
create index if not exists idx_payments_paid_on on payments(paid_on);

create view reports as
select p.paid_on as report_date,
       sum(p.amount) as total_collection,
       count(*) as transactions
from payments p
group by p.paid_on;
