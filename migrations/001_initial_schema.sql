-- Companies
CREATE TABLE companies (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    short_name TEXT NOT NULL,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now()
);

INSERT INTO companies (name, short_name) VALUES
    ('Owens World Air', 'OWA'),
    ('ULD Logistics', 'ULD');

-- Contacts
CREATE TABLE contacts (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    company_name TEXT,
    email TEXT,
    phone TEXT,
    contact_type TEXT NOT NULL,
    is_staff BOOLEAN DEFAULT false,
    is_customer BOOLEAN DEFAULT false,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Vehicles
CREATE TABLE vehicles (
    id SERIAL PRIMARY KEY,
    company_id INTEGER REFERENCES companies(id),
    name TEXT NOT NULL,
    type TEXT,
    plate TEXT,
    active BOOLEAN DEFAULT true,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Jobs
CREATE TABLE jobs (
    id SERIAL PRIMARY KEY,
    job_key TEXT UNIQUE NOT NULL,
    company_id INTEGER REFERENCES companies(id),
    customer_id INTEGER REFERENCES contacts(id),
    job_type TEXT,
    direction TEXT,
    pieces INTEGER,
    weight_kg DECIMAL(10,2),
    length_cm DECIMAL(8,2),
    width_cm DECIMAL(8,2),
    height_cm DECIMAL(8,2),
    inbound_carrier TEXT,
    outbound_carrier TEXT,
    carnet BOOLEAN DEFAULT false,
    pmc BOOLEAN DEFAULT false,
    screening_required BOOLEAN DEFAULT false,
    after_hours BOOLEAN DEFAULT false,
    airfreight_cost DECIMAL(10,2),
    airfreight_markup DECIMAL(10,2),
    est_charge DECIMAL(10,2),
    final_charge DECIMAL(10,2),
    invoice_sent BOOLEAN DEFAULT false,
    invoice_sent_at TIMESTAMPTZ,
    invoice_notes TEXT,
    paid BOOLEAN DEFAULT false,
    paid_at TIMESTAMPTZ,
    parent_job_id INTEGER REFERENCES jobs(id),
    status TEXT DEFAULT 'active',
    ref_numbers TEXT,
    email_subject TEXT,
    flags TEXT,
    notes TEXT,
    archived BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Job staff
CREATE TABLE job_staff (
    id SERIAL PRIMARY KEY,
    job_key TEXT REFERENCES jobs(job_key) ON DELETE CASCADE,
    contact_id INTEGER REFERENCES contacts(id),
    role TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Job events
CREATE TABLE job_events (
    id SERIAL PRIMARY KEY,
    job_key TEXT REFERENCES jobs(job_key) ON DELETE CASCADE,
    event_type TEXT NOT NULL,
    scheduled_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    location TEXT,
    address TEXT,
    contact_id INTEGER REFERENCES contacts(id),
    driver_id INTEGER REFERENCES contacts(id),
    vehicle_id INTEGER REFERENCES vehicles(id),
    third_party TEXT,
    charge DECIMAL(10,2),
    notes TEXT,
    done BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Charges
CREATE TABLE charges (
    id SERIAL PRIMARY KEY,
    job_key TEXT REFERENCES jobs(job_key) ON DELETE CASCADE,
    description TEXT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    charge_type TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Attachments
CREATE TABLE attachments (
    id SERIAL PRIMARY KEY,
    job_key TEXT REFERENCES jobs(job_key) ON DELETE CASCADE,
    filename TEXT,
    filepath TEXT,
    content_type TEXT,
    message_id TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Processed emails
CREATE TABLE processed_emails (
    message_id TEXT PRIMARY KEY,
    processed_at TIMESTAMPTZ DEFAULT now()
);

-- Prompt history
CREATE TABLE prompt_history (
    id SERIAL PRIMARY KEY,
    prompt TEXT,
    reason TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);
