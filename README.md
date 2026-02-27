# Supabase SwiftUI Starter

A minimal iOS 26 starter project demonstrating **Supabase** integration with **SwiftUI** — no authentication required. Build a fully functional news app with image uploads in minutes.

Perfect for beginners who want to learn how to connect a SwiftUI app to a real backend using Supabase for CRUD operations and file storage.


## What This Project Does

This is a simple two-tab iOS app:

**News Tab** — A list of articles fetched from Supabase. Each article has a title, an image, and a creation date. You can add new articles with photos from your library, pull to refresh, and swipe to delete.

**Profile Tab** — A profile editor where you can set your first name, last name, and upload an avatar photo. Everything is saved to Supabase.

All images (article photos and avatar) are uploaded to Supabase Storage and stored as public URLs in the database.

There is no authentication. This is intentional — the project is designed as a learning tool and starting point, not a production app.


## Tech Stack

- **SwiftUI** — iOS 26+ with modern APIs (async/await, PhotosPicker, AsyncImage, ContentUnavailableView)
- **Supabase** — Backend-as-a-Service (PostgreSQL database + object storage)
- **Supabase Swift SDK** — Official Swift client for Supabase


## SPM Dependencies

The only external dependency is the official Supabase Swift SDK:

```
https://github.com/supabase/supabase-swift
```

Select the **Supabase** library when adding the package.


## Project Structure

```
supabase-swiftui-starter/
├── SupabaseStarterApp.swift   → App entry point (@main)
├── SupabaseManager.swift      → Supabase client singleton (add your credentials here)
├── Models.swift               → Codable data models (Article, Profile)
├── ContentView.swift          → Main TabView (News + Profile)
├── ArticleListView.swift      → Fetches, displays, and deletes articles
├── ArticleRowView.swift       → Single article row (image + title + date)
├── AddArticleView.swift       → Form to create a new article with image upload
├── ProfileView.swift          → Profile editor with avatar upload
├── setup.sql                  → SQL queries to set up your Supabase database
└── README.md
```


## Supabase Setup (Step by Step)

If you've never used Supabase before, follow every step below. If you already have an account, skip to Step 2.

### Step 1 — Create a Supabase Account

1. Go to [supabase.com](https://supabase.com)
2. Click **Start your project** and sign up with GitHub or email
3. Once logged in, you'll land on the Supabase Dashboard

### Step 2 — Create a New Project

1. Click **New Project**
2. Choose your organization (or create one)
3. Set a **project name** (e.g. `swiftui-starter`)
4. Set a **database password** (save it somewhere — you won't need it in the app but you'll need it for direct DB access)
5. Choose a **region** close to you
6. Click **Create new project** and wait for it to finish provisioning (about 1-2 minutes)

### Step 3 — Get Your API Credentials

1. In the left sidebar, go to **Settings** (gear icon at the bottom)
2. Click **API** under Configuration
3. Copy these two values — you'll need them later:
   - **Project URL** — looks like `https://abcdefg.supabase.co`
   - **anon public** key — a long string starting with `eyJ...`

### Step 4 — Create the Database Tables

1. In the left sidebar, click **SQL Editor**
2. Click **New query**
3. Paste the following SQL and click **Run**:

```sql
-- ============================================
-- supabase-swiftui-starter — Database Setup
-- ============================================

-- Articles table
CREATE TABLE articles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    image_url TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Profile table (single row, no authentication)
CREATE TABLE profile (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    first_name TEXT NOT NULL DEFAULT '',
    last_name TEXT NOT NULL DEFAULT '',
    avatar_url TEXT
);

-- Insert a default empty profile
INSERT INTO profile (first_name, last_name) VALUES ('', '');
```

4. You should see **Success. No rows returned** — that's correct
5. Now run a second query to set up the security policies:

```sql
-- ============================================
-- Row Level Security — Allow All (No Auth)
-- ============================================

ALTER TABLE articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE profile ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all on articles" ON articles
    FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Allow all on profile" ON profile
    FOR ALL USING (true) WITH CHECK (true);
```

This enables Row Level Security but allows all operations without requiring authentication. This is fine for learning, but in production you should use proper auth-based policies.

### Step 5 — Create Storage Buckets

1. In the left sidebar, click **Storage**
2. Click **New bucket**
3. Create the first bucket:
   - Name: `article-images`
   - Toggle **Public bucket** to ON
   - Click **Create bucket**
4. Create the second bucket:
   - Name: `avatars`
   - Toggle **Public bucket** to ON
   - Click **Create bucket**

### Step 6 — Set Storage Policies

For each bucket, you need to allow uploads and downloads without authentication.

**For the `article-images` bucket:**

1. Click on `article-images` in the Storage sidebar
2. Click the **Policies** tab (or go to **Configuration** → **Policies**)
3. Click **New policy**
4. Select **For full customization**
5. Set:
   - Policy name: `Allow all`
   - Allowed operations: check **SELECT**, **INSERT**, **DELETE**
   - Target roles: leave default
   - USING expression: `true`
   - WITH CHECK expression: `true`
6. Click **Review** then **Save policy**

**Repeat the exact same steps for the `avatars` bucket.**

Your Supabase backend is now ready.


## Xcode Setup

1. Clone this repo:
   ```bash
   git clone https://github.com/user/supabase-swiftui-starter.git
   ```

2. Open the project in Xcode 26+

3. Add the Supabase Swift SDK:
   - Go to **File → Add Package Dependencies**
   - Enter: `https://github.com/supabase/supabase-swift`
   - Click **Add Package**
   - Select the **Supabase** library and click **Add Package**

4. Open `SupabaseManager.swift` and replace the placeholders:
   ```swift
   private static let projectURL = URL(string: "https://YOUR_PROJECT_ID.supabase.co")!
   private static let anonKey = "YOUR_ANON_KEY_HERE"
   ```

5. Build and run on a simulator or device (iOS 26+)


## How It Works

- **Database** — The app reads and writes to PostgreSQL tables (`articles`, `profile`) using the Supabase Swift SDK's query builder with async/await.
- **Storage** — Images are compressed to JPEG, uploaded to Supabase Storage buckets, and their public URLs are saved in the database. The app uses `AsyncImage` to load them.
- **No Auth** — RLS is enabled with permissive policies. All operations are allowed without a logged-in user. This keeps the code simple and focused on learning Supabase basics.


## Next Steps

When you're ready to add authentication:

1. Enable an auth provider in Supabase Dashboard (Email, Google, Apple, etc.)
2. Use `SupabaseManager.client.auth.signIn()` and `.signUp()` in your app
3. Replace the RLS policies to use `auth.uid()` instead of `true`
4. Add a login/signup screen and gate the main content behind auth state


## License

MIT License — see [LICENSE](LICENSE) for details.


## Author

Made by [Withnico](https://withnico.com) — iOS Developer and Content Creator.

Feel free to star the repo if you find it useful.


---


# supabase-swiftui-starter (Italiano)

Un progetto starter minimale per iOS 26 che dimostra l'integrazione di **Supabase** con **SwiftUI** — senza autenticazione.

Perfetto per chi vuole imparare a connettere un'app SwiftUI a un backend reale usando Supabase per operazioni CRUD e upload di immagini.


## Cosa Fa Questo Progetto

L'app ha due sezioni:

**Tab News** — Una lista di articoli scaricati da Supabase. Ogni articolo ha un titolo, un'immagine e una data di creazione. Puoi aggiungere nuovi articoli con foto dalla libreria, aggiornare con pull-to-refresh e cancellare con swipe.

**Tab Profilo** — Un editor dove puoi impostare nome, cognome e caricare una foto profilo. Tutto viene salvato su Supabase.

Tutte le immagini vengono caricate su Supabase Storage e salvate come URL pubblici nel database.

Non c'è autenticazione. Questa è una scelta intenzionale — il progetto è pensato come strumento di apprendimento, non come app di produzione.


## Stack Tecnologico

- **SwiftUI** — iOS 26+ con API moderne (async/await, PhotosPicker, AsyncImage, ContentUnavailableView)
- **Supabase** — Backend-as-a-Service (database PostgreSQL + storage oggetti)
- **Supabase Swift SDK** — Client Swift ufficiale per Supabase


## Dipendenze SPM

L'unica dipendenza esterna è il Supabase Swift SDK ufficiale:

```
https://github.com/supabase/supabase-swift
```

Seleziona la libreria **Supabase** quando aggiungi il pacchetto.


## Struttura del Progetto

```
supabase-swiftui-starter/
├── SupabaseStarterApp.swift   → Entry point dell'app (@main)
├── SupabaseManager.swift      → Singleton Supabase (inserisci qui le tue credenziali)
├── Models.swift               → Modelli Codable (Article, Profile)
├── ContentView.swift          → TabView principale (News + Profilo)
├── ArticleListView.swift      → Fetch, visualizzazione e cancellazione articoli
├── ArticleRowView.swift       → Riga singola (immagine + titolo + data)
├── AddArticleView.swift       → Form per creare un articolo con upload immagine
├── ProfileView.swift          → Editor profilo con upload avatar
├── setup.sql                  → Query SQL per configurare il database Supabase
└── README.md
```


## Configurazione Supabase (Passo per Passo)

Se non hai mai usato Supabase, segui ogni passaggio. Se hai già un account, vai al Passo 2.

### Passo 1 — Crea un Account Supabase

1. Vai su [supabase.com](https://supabase.com)
2. Clicca **Start your project** e registrati con GitHub o email
3. Una volta dentro, ti troverai nella Dashboard di Supabase

### Passo 2 — Crea un Nuovo Progetto

1. Clicca **New Project**
2. Scegli la tua organizzazione (o creane una)
3. Imposta un **nome progetto** (es. `swiftui-starter`)
4. Imposta una **password per il database** (salvala da qualche parte — non ti servirà nell'app ma per l'accesso diretto al DB)
5. Scegli una **regione** vicina a te
6. Clicca **Create new project** e aspetta 1-2 minuti

### Passo 3 — Ottieni le Credenziali API

1. Nella barra laterale, vai su **Settings** (icona ingranaggio in basso)
2. Clicca **API** sotto Configuration
3. Copia questi due valori:
   - **Project URL** — tipo `https://abcdefg.supabase.co`
   - **anon public** key — una stringa lunga che inizia con `eyJ...`

### Passo 4 — Crea le Tabelle del Database

1. Nella barra laterale, clicca **SQL Editor**
2. Clicca **New query**
3. Incolla il seguente SQL e clicca **Run**:

```sql
-- ============================================
-- supabase-swiftui-starter — Setup Database
-- ============================================

-- Tabella articoli
CREATE TABLE articles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    image_url TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Tabella profilo (riga singola, senza autenticazione)
CREATE TABLE profile (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    first_name TEXT NOT NULL DEFAULT '',
    last_name TEXT NOT NULL DEFAULT '',
    avatar_url TEXT
);

-- Inserisci un profilo vuoto di default
INSERT INTO profile (first_name, last_name) VALUES ('', '');
```

4. Dovresti vedere **Success. No rows returned** — è corretto
5. Ora esegui una seconda query per le policy di sicurezza:

```sql
-- ============================================
-- Row Level Security — Permetti Tutto (No Auth)
-- ============================================

ALTER TABLE articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE profile ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all on articles" ON articles
    FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Allow all on profile" ON profile
    FOR ALL USING (true) WITH CHECK (true);
```

Questo abilita la Row Level Security ma permette tutte le operazioni senza autenticazione. Va bene per imparare, ma in produzione dovresti usare policy basate sull'autenticazione.

### Passo 5 — Crea i Bucket di Storage

1. Nella barra laterale, clicca **Storage**
2. Clicca **New bucket**
3. Crea il primo bucket:
   - Nome: `article-images`
   - Attiva **Public bucket**
   - Clicca **Create bucket**
4. Crea il secondo bucket:
   - Nome: `avatars`
   - Attiva **Public bucket**
   - Clicca **Create bucket**

### Passo 6 — Imposta le Policy di Storage

Per ogni bucket devi permettere upload e download senza autenticazione.

**Per il bucket `article-images`:**

1. Clicca su `article-images` nella barra laterale dello Storage
2. Clicca la tab **Policies** (o vai su **Configuration** → **Policies**)
3. Clicca **New policy**
4. Seleziona **For full customization**
5. Imposta:
   - Policy name: `Allow all`
   - Allowed operations: seleziona **SELECT**, **INSERT**, **DELETE**
   - Target roles: lascia il default
   - USING expression: `true`
   - WITH CHECK expression: `true`
6. Clicca **Review** poi **Save policy**

**Ripeti gli stessi identici passaggi per il bucket `avatars`.**

Il tuo backend Supabase è pronto.


## Configurazione Xcode

1. Clona questo repo:
   ```bash
   git clone https://github.com/user/supabase-swiftui-starter.git
   ```

2. Apri il progetto in Xcode 26+

3. Aggiungi il Supabase Swift SDK:
   - Vai su **File → Add Package Dependencies**
   - Inserisci: `https://github.com/supabase/supabase-swift`
   - Clicca **Add Package**
   - Seleziona la libreria **Supabase** e clicca **Add Package**

4. Apri `SupabaseManager.swift` e sostituisci i placeholder:
   ```swift
   private static let projectURL = URL(string: "https://YOUR_PROJECT_ID.supabase.co")!
   private static let anonKey = "YOUR_ANON_KEY_HERE"
   ```

5. Builda e avvia su simulatore o dispositivo (iOS 26+)


## Come Funziona

- **Database** — L'app legge e scrive su tabelle PostgreSQL (`articles`, `profile`) usando il query builder del Supabase Swift SDK con async/await.
- **Storage** — Le immagini vengono compresse in JPEG, caricate sui bucket di Supabase Storage, e i loro URL pubblici vengono salvati nel database. L'app usa `AsyncImage` per caricarle.
- **Nessuna Auth** — La RLS è abilitata con policy permissive. Tutte le operazioni sono consentite senza un utente loggato. Questo mantiene il codice semplice e focalizzato sull'apprendimento delle basi di Supabase.


## Prossimi Passi

Quando sei pronto per aggiungere l'autenticazione:

1. Abilita un provider di auth nella Dashboard Supabase (Email, Google, Apple, ecc.)
2. Usa `SupabaseManager.client.auth.signIn()` e `.signUp()` nella tua app
3. Sostituisci le policy RLS usando `auth.uid()` al posto di `true`
4. Aggiungi una schermata login/registrazione e mostra il contenuto principale solo dopo l'autenticazione


## Licenza

MIT License — vedi [LICENSE](LICENSE) per i dettagli.


## Autore

Creato da [Withnico](https://withnico.com) — iOS Developer e Content Creator.

Se il progetto ti è utile, lascia una stella al repo.
