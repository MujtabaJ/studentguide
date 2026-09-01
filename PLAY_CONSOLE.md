# Play Console — exact answers for Student Guide

Use this while you are in [Play Console](https://play.google.com/console) → **Student Guide** → **Policy and programs** → **App content**, then **Grow users** → **Store presence** → **Main store listing**.

Package: `com.audrey.student.guide`

---

## 0. Privacy policy URL

**Use this URL in Play Console:**

https://mujtabaj.github.io/studentguide/

It is the GitHub Pages site for this repo (`docs/index.html`). After the first push it can take 1–2 minutes to go live.

If the link 404s, wait a minute, or in the GitHub repo open **Settings → Pages** and set Source to **Deploy from a branch**, branch **main**, folder **/docs**.

---

## Policy and programs → App content

Complete these in roughly this order. Privacy policy and ads should be done before target audience.

### 1. Set privacy policy

- Click **Start** / **Add**
- **Privacy policy URL:** https://mujtabaj.github.io/studentguide/
- **Save**

### 2. Sign in details (App access)

Student Guide has **no accounts**.

- Click **Start**
- Select **No** / **All functionality is available without any restrictions**  
  (wording may be: *“All functionality is available”* or *“My app does not have any restricted content”*)
- Do **not** add test usernames or passwords
- **Save**

If you only see *“Are there any parts of your app that are restricted by login credentials?”* → **No**.

### 3. Ads

- Click **Start**
- Select **No, my app does not contain ads**
- **Save**

There is no AdMob, no banners, no “Contains ads” label.

### 4. Content rating (IARC questionnaire)

- Click **Start** → **Start questionnaire**
- **Email:** the address you use for Play Console (IARC will mail the certificate here)
- **Category:** **Utility, Productivity, Communication** *or* **Educational / Reference** if that option is listed  
  Prefer **Educational** if you must pick one. If the form only has broad buckets, pick **Utility / Productivity**.
- Click **Next**

Answer **No** to every content question, including:

| Question (wording varies) | Answer |
|---|---|
| Violence | No |
| Blood / gore | No |
| Sexual content / nudity | No |
| Language / profanity | No |
| Controlled substances (alcohol, tobacco, drugs) | No |
| Gambling or simulated gambling | No |
| Horror / fear | No |
| Crude humor | No |
| User-generated content shared with others | No |
| Users can communicate / interact with each other | No |
| Location sharing | No |
| Digital purchases / in-app purchases | No |
| Unrestricted internet access / web browser | No |
| Ads inside the app | No |
| Age-restricted content | No |

Then **Save** → **Next** → **Submit**.

Expected result: **Everyone** (US) / **PEGI 3** / similar “all ages” labels. Google assigns the official rating after submit; you do not type the rating yourself.

### 5. Target audience

Pick **teen and adult students**, not young children. That matches a high-school / college planner and **avoids** the Designed for Families extra review.

- Click **Start**
- **Target age groups — check only:**
  - **13–15**
  - **16–17**
  - **18 and over**
- Leave **unchecked:** Ages 5 and under, 6–8, 9–12
- **Next**
- *Could your store listing appeal to children?* → **No**
- Appeal to children questions / Teacher Approved → skip or **No**
- **Does your app collect personal or sensitive information from children?** → **No** (we do not collect data at all)
- **Save**

Do not enable “Restrict minor access” (that is only if 18+ is the *only* group).

### 6. Data safety

- Click **Start**
- **Does your app collect or share any of the required user data types?** → **No**
- You should **not** tick name, email, photos, location, device IDs, etc.
- On-device notes/tasks/GPA stay on the phone. Google’s form is about data **your app or SDKs send off the device**. This app does not.
- **Is all user data encrypted in transit?** — only appears if you said Yes to collection. Skip.
- **Do you provide a way for users to request that their data is deleted?** — skip if collection is No. (Users can still wipe data in **Settings → Clear all data**.)
- **Does your app use advertising ID?** → **No** (if asked)
- Preview the Data safety listing: it should say the app **does not collect** user data
- **Submit** / **Save**

Your privacy policy text must stay consistent with this (**no collection, no ads, no accounts**).

### 7. Government apps

- Click **Start**
- **Is this a government app?** (national, state, city, or local authority) → **No**
- **Save**

### 8. Financial features

- Click **Start**
- Select **My app doesn’t provide any financial features**
- GPA / credits are school grades, not banking, payments, loans, crypto, or wallets
- **Next** → **Save**

### 9. Health

- Click **Start declaration**
- Select **My app does not have any health features**
- Study tips about sleep/focus are educational text, not health/fitness tracking or medical features
- **Save**

### Other App content items (if they appear)

| Section | Answer |
|---|---|
| News apps | **No** — not a news app |
| COVID-19 contact tracing / status | **None of these apply** / **No** |
| Foreground service permissions | Skip unless asked. This app does not use foreground services |
| Photos and videos permissions | Skip. App does not use camera/gallery |
| Health Connect | **No** if asked |

---

## Store presence → App category and contact

**Grow users** → **Store settings** (or **Main store listing** contact / **Store settings**)

### Category

- **App category:** **Education**
- **Tags** (pick up to 5, if offered): Education, Productivity, Study, Student, Tools

### Contact details

Play shows these on the store listing.

- **Email (required):** the inbox you will actually read (usually your Play Console Google account email)
- **Phone:** optional
- **Website:** paste the **same privacy policy URL**
- **External marketing:** leave off unless you have a real marketing site

---

## Store presence → Main store listing

**Default language:** English (United States) — or English (United Kingdom) if that is your account default.

### Text (copy-paste)

**App name** (max 30 characters):

```
Student Guide
```

**Short description** (max 80 characters):

```
Plan classes, tasks, and exams. Track GPA and study with a timer and flashcards.
```

**Full description:**

```
Student Guide helps you stay on top of school without an account or ads.

• Home dashboard with today’s classes, due work, exam countdown, GPA, and study streak
• Planner for assignments, a weekly timetable, and exams
• Subjects with credits, weighted scores, and a 4.0 GPA
• Notes and flashcard decks for active recall
• Pomodoro study timer with a daily minute goal
• Study tips for recall, exams, notes, and wellbeing
• Light and dark theme
• Export or import a backup JSON file

Your data stays on this device. There are no ads, no tracking, and no sign-in.
```

### Graphics (upload from this project)

| Asset | Play size | File |
|---|---|---|
| High-res icon | 512 × 512 PNG | `assets/store/play_icon_512.png` |
| Feature graphic | 1024 × 500 PNG | `assets/store/feature_graphic_1024x500.png` |
| Phone screenshots | 1170 × 2532 JPEG (up to 8) | `assets/store/screenshots/play/` |

Upload these **in this order** under Phone screenshots:

1. `01_home.jpg` — dashboard
2. `02_planner_tasks.jpg` — tasks
3. `03_timetable.jpg` — weekly schedule
4. `04_exams.jpg` — exam countdown
5. `05_study.jpg` — study hub
6. `06_timer.jpg` — Pomodoro timer
7. `07_flashcards.jpg` — flashcard decks
8. `08_grades.jpg` — GPA

They are 24-bit JPEGs (no alpha), which Play Console accepts.

Tablet screenshots are optional.

Promo video is optional.

### After you save the listing

On the **Dashboard** / **Publishing overview**, every item should show a green check. Then send the app for **review** (Production or a testing track, depending on how you uploaded the AAB).

---

## Quick checklist

- [ ] Privacy policy URL live and opens while logged out
- [ ] Sign in details: no login
- [ ] Ads: No
- [ ] Content rating submitted
- [ ] Target audience: 13–15, 16–17, 18+
- [ ] Data safety: does not collect data
- [ ] Government: No
- [ ] Financial: none
- [ ] Health: none
- [ ] Category: Education + contact email
- [ ] Store listing text + 512 icon + 1024×500 graphic + 8 phone JPEGs in `assets/store/screenshots/play/`
