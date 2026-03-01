--
--  setup.sql
--  supabase-swiftui-starter
--
--  Created by Nicolò Curioni 🔸
--  Founder of withnico.com and codico.org
--

-- ============================================================
-- Run this SQL in the Supabase SQL Editor to set up the schema
-- Esegui questo SQL nell'Editor SQL di Supabase per
-- configurare lo schema del database
-- ============================================================

-- -----------------------------------------------
-- 1. Articles table
--    Stores articles with a title, optional image,
--    and automatic creation timestamp.
--
--    Tabella articoli
--    Memorizza gli articoli con un titolo, un'immagine
--    opzionale e un timestamp di creazione automatico.
-- -----------------------------------------------
CREATE TABLE articles (
    id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    title      TEXT        NOT NULL,
    image_url  TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- -----------------------------------------------
-- 2. Profile table
--    Stores user profile information with first name,
--    last name, and an optional avatar URL.
--
--    Tabella profilo
--    Memorizza le informazioni del profilo utente con nome,
--    cognome e un URL avatar opzionale.
-- -----------------------------------------------
CREATE TABLE profile (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name TEXT NOT NULL DEFAULT '',
    last_name  TEXT NOT NULL DEFAULT '',
    avatar_url TEXT
);

-- -----------------------------------------------
-- 3. Insert a default empty profile row
--    Inserisce una riga di profilo vuota predefinita
-- -----------------------------------------------
INSERT INTO profile (first_name, last_name)
VALUES ('', '');

-- -----------------------------------------------
-- 4. Enable Row Level Security (RLS)
--    Permissive policies allow all operations
--    without authentication for development.
--
--    Abilita la sicurezza a livello di riga (RLS)
--    Le policy permissive consentono tutte le operazioni
--    senza autenticazione per lo sviluppo.
-- -----------------------------------------------

-- Enable RLS on articles
-- Abilita RLS sulla tabella articoli
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all access on articles"
    ON articles
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- Enable RLS on profile
-- Abilita RLS sulla tabella profilo
ALTER TABLE profile ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all access on profile"
    ON profile
    FOR ALL
    USING (true)
    WITH CHECK (true);
