(() => {
  'use strict';

  /* ---------- Prefs ---------- */

  const store = {
    get(key, fallback) {
      try {
        const v = localStorage.getItem('ep:' + key);
        return v === null ? fallback : JSON.parse(v);
      } catch {
        return fallback;
      }
    },
    set(key, value) {
      try {
        localStorage.setItem('ep:' + key, JSON.stringify(value));
      } catch {
        /* storage unavailable: prefs just don't persist */
      }
    },
  };

  const prefs = {
    theme: store.get('theme', 'system'),
    width: store.get('width', '360'),
    long: store.get('long', 'off'),
    motion: store.get('motion', 'on'),
    role: store.get('role', 'trainer'),
    load: 'loaded',
    pt: 'active',
    view: store.get('view', 'dossier'),
  };
  const persisted = ['theme', 'width', 'long', 'motion', 'role', 'view'];

  // Shareable review states, e.g. ?theme=light&width=320&long=on&role=admin
  const params = new URLSearchParams(location.search);
  Object.keys(prefs).forEach((key) => {
    if (params.has(key)) prefs[key] = params.get(key);
  });

  /* ---------- Icons (one 1.75 stroke family) ---------- */

  const p = (d) => `<path d="${d}"/>`;
  const c = (x, y, r, fill) => `<circle cx="${x}" cy="${y}" r="${r}"${fill ? ' class="f"' : ''}/>`;
  const I = {
    back: p('M15 5l-7 7 7 7'),
    edit: p('M4 20h4L19 9l-4-4L4 16v4z') + p('M13.5 6.5l4 4'),
    close: p('M6 6l12 12M18 6L6 18'),
    plus: p('M12 5v14M5 12h14'),
    minus: p('M6 12h12'),
    chev: p('M9.5 6l6 6-6 6'),
    chevDown: p('M6 9.5l6 6 6-6'),
    grip: c(9, 7, 1.3, 1) + c(15, 7, 1.3, 1) + c(9, 12, 1.3, 1) + c(15, 12, 1.3, 1) + c(9, 17, 1.3, 1) + c(15, 17, 1.3, 1),
    up: p('M12 19V5M6 11l6-6 6 6'),
    down: p('M12 5v14M6 13l6 6 6-6'),
    swap: p('M5 8h13l-3.5-3.5M19 16H6l3.5 3.5'),
    trash: p('M5 7h14M10 7V4.5h4V7M7 7l1 13h8l1-13'),
    search: c(11, 11, 6.2) + p('M20 20l-4.6-4.6'),
    home: p('M4 11l8-7 8 7v9h-5.5v-6h-5v6H4z'),
    people: c(9, 8, 3.2) + p('M3.5 19.5c.8-3.3 3-5.2 5.5-5.2s4.7 1.9 5.5 5.2M15.5 5a3 3 0 010 6M17 14.2c2 .6 3.2 2.3 3.6 5.3'),
    plans: p('M9 4h6v3H9z') + p('M9 5.5H6.5v15h11v-15H15') + p('M9.5 12h5M9.5 15.5h3.5'),
    calendar: '<rect x="4" y="5.5" width="16" height="14.5" rx="2.5"/>' + p('M4 10h16M8.5 3.5v4M15.5 3.5v4'),
    user: c(12, 8, 3.6) + p('M5 20c1-3.6 3.8-5.6 7-5.6s6 2 7 5.6'),
    gauge: p('M4 16.5a8 8 0 1116 0') + p('M12 16.5l4-5'),
    card: '<rect x="3" y="6" width="18" height="13" rx="2.5"/>' + p('M3 10.5h18M7 15h4'),
    wallet: p('M4 7.5h14.5a1.5 1.5 0 011.5 1.5v9.5a1.5 1.5 0 01-1.5 1.5H4z') + p('M4 7.5V6a2 2 0 012-2h10') + c(16, 14, 1.2, 1),
    dots: c(6, 12, 1.6, 1) + c(12, 12, 1.6, 1) + c(18, 12, 1.6, 1),
    phone: p('M7 4h2.6l1.4 4-2 1.4a10.5 10.5 0 005.6 5.6l1.4-2 4 1.4V17a3 3 0 01-3 3A15 15 0 014 7a3 3 0 013-3z'),
    mail: '<rect x="3.5" y="6" width="17" height="12.5" rx="2.5"/>' + p('M4.5 7.5l7.5 6 7.5-6'),
    heart: p('M12 19.5s-7.5-4.5-7.5-10A4 4 0 0112 7.3a4 4 0 017.5 2.2c0 5.5-7.5 10-7.5 10z'),
    pulse: p('M3 12.5h4l2.2-5.5 4.2 11 2.2-5.5H21'),
    sos: c(12, 12, 8.5) + p('M12 8v8M8 12h8'),
    doc: p('M7 3.5h7l4 4v13H7z') + p('M13.5 3.5V8H18M10 13h5M10 16.5h5'),
    image: '<rect x="4" y="5" width="16" height="14" rx="2.5"/>' + c(9.5, 10, 1.6) + p('M5 17.5l4.5-4 3.5 3 2.5-2 3.5 3'),
    target: c(12, 12, 8.5) + c(12, 12, 4.8) + c(12, 12, 1.3, 1),
    dumbbell: p('M6.5 7.5v9M17.5 7.5v9M3.8 10v4M20.2 10v4M6.5 12h11'),
    bowl: p('M4 11.5h16a8 8 0 01-16 0z') + p('M9.5 8c0-1.4 1-1.9 1-3.4M13.5 8c0-1.4 1-1.9 1-3.4'),
    play: p('M8 5.5v13l10.5-6.5z'),
    alert: p('M12 4.5l8.5 15h-17z') + p('M12 10.5v4') + c(12, 17, 0.9, 1),
    gender: c(12, 9, 4.5) + p('M12 13.5V20M9 17.5h6'),
  };
  const ico = (name, cls = '') => `<svg class="ico ${cls}" viewBox="0 0 24 24" aria-hidden="true">${I[name]}</svg>`;
  const esc = (s) => String(s ?? '').replace(/[&<>"']/g, (ch) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[ch]);
  const nia = (label, tight = false) =>
    `<span class="nia${tight ? ' tight' : ''}" role="img" aria-label="${esc(label)}"><svg viewBox="0 0 28 28"><circle cx="14" cy="14" r="10.5"/></svg></span>`;
  const rise = (i) => `rise" style="--i:${i}`;

  /* ---------- People ---------- */

  const people = () =>
    prefs.long === 'on'
      ? {
          member: 'Ananya Lakshmi Raghunathan-Venkatasubramanian',
          memberShort: 'Ananya Lakshmi Raghunathan-Venkatasubramanian',
          memberInit: 'AR',
          trainer: 'Rohan Menon Thekkumpurathu Sebastian',
          email: 'ananya.lakshmi.raghunathan.v@protonmail.com',
        }
      : {
          member: 'Ananya Raghunathan',
          memberShort: 'Ananya Raghunathan',
          memberInit: 'AR',
          trainer: 'Rohan Menon',
          email: 'ananya.r@protonmail.com',
        };

  const KNEE_NOTE = 'Left knee: avoid deep lunges until the physio clears it.';

  /* ---------- Dossier state ---------- */

  const D = {
    editing: false,
    first: 'Ananya',
    last: 'Raghunathan',
    phone: '+91 98471 20386',
    gender: 'Female',
    notes: KNEE_NOTE,
    emailOverride: null,
    firstError: false,
    renewMethod: null,
  };

  /* ---------- Builder state ---------- */

  let uid = 0;
  const ex = (name, day, sets, reps, kg, rest, after = null) => ({ id: ++uid, name, day, sets, reps, kg, rest, after });

  const initialPlan = () => ({
    title: 'Hypertrophy block A',
    description: 'Push, pull, legs. Add load once every set reaches the top of the rep range.',
    goal: 'Gain 3 kg lean mass',
    difficulty: 'Intermediate',
    weeks: 6,
    template: false,
    status: 'Draft',
    exercises: [
      ex('Barbell bench press', 1, 4, '6–8', 70, 120),
      ex('Incline dumbbell press', 1, 3, '8–10', 24, 90),
      ex('Standing overhead press', 1, 3, '8', 40, 90),
      ex('Seated cable fly', 1, 3, '12–15', 15, 60),
      ex('Single-arm cable triceps extension behind the head', 1, 3, '12', 10, 60),
      ex('Weighted pull-up', 2, 4, '5', 10, 120),
      ex('Chest-supported T-bar row', 2, 3, '8–10', 45, 90),
      ex('Face pull', 2, 3, '15', 20, 60),
      ex('Incline dumbbell curl', 2, 3, '10', 10, 60),
      ex('Back squat', 3, 4, '5', 90, 150),
      ex('Romanian deadlift with pause below the knee', 3, 3, '8', 80, 120),
      ex('Leg press', 3, 3, '10', 160, 90),
      ex('Seated leg curl', 3, 3, '12', 40, 60),
      ex('Standing calf raise', 3, 4, '12', 60, 45),
    ],
  });

  const B = Object.assign(initialPlan(), {
    dirty: false,
    saving: false,
    detailsOpen: false,
    titleError: false,
    day: 1,
    open: null,
    pickDay: 1,
    pickQuery: '',
    pickMuscle: 'All',
    justAdded: null,
  });
  let snapshot = JSON.stringify(initialPlan());

  const LIBRARY = [
    ['Barbell bench press', 'Chest', 'Barbell'],
    ['Incline dumbbell press', 'Chest', 'Dumbbells'],
    ['Seated cable fly', 'Chest', 'Cable'],
    ['Deficit push-up on parallettes', 'Chest', 'Bodyweight'],
    ['Weighted pull-up', 'Back', 'Dip belt'],
    ['Chest-supported T-bar row', 'Back', 'Machine'],
    ['Single-arm half-kneeling lat pulldown', 'Back', 'Cable'],
    ['Face pull', 'Shoulders', 'Cable'],
    ['Standing overhead press', 'Shoulders', 'Barbell'],
    ['Cable lateral raise', 'Shoulders', 'Cable'],
    ['Back squat', 'Legs', 'Barbell'],
    ['Romanian deadlift with pause below the knee', 'Legs', 'Barbell'],
    ['Leg press', 'Legs', 'Machine'],
    ['Seated leg curl', 'Legs', 'Machine'],
    ['Standing calf raise', 'Legs', 'Machine'],
    ['Incline dumbbell curl', 'Arms', 'Dumbbells'],
    ['Single-arm cable triceps extension behind the head', 'Arms', 'Cable'],
    ['Hammer curl', 'Arms', 'Dumbbells'],
    ['Dead bug', 'Core', 'Bodyweight'],
    ['Pallof press', 'Core', 'Cable'],
    ['Hanging knee raise', 'Core', 'Pull-up bar'],
  ];
  const MUSCLES = ['All', 'Chest', 'Back', 'Legs', 'Shoulders', 'Arms', 'Core'];
  const DEFAULT_REST = 60;

  const fmtKg = (kg) => (Number.isInteger(kg) ? String(kg) : kg.toFixed(1));
  const exOf = (day) => B.exercises.filter((e) => e.day === day);
  const dayList = () => {
    const set = new Set(B.exercises.map((e) => e.day));
    set.add(B.day);
    return [...set].sort((a, b) => a - b);
  };
  const maxDay = () => Math.max(0, ...B.exercises.map((e) => e.day));
  const summary = (e) =>
    `${e.sets} × ${e.reps || '—'}${e.kg != null ? ` at ${fmtKg(e.kg)} kg` : ''}, ${e.rest ?? DEFAULT_REST}s rest`;
  const dayMinutes = (list) => {
    let s = 0;
    list.forEach((e, i) => {
      const rest = e.rest ?? DEFAULT_REST;
      s += e.sets * 45 + Math.max(0, e.sets - 1) * rest;
      if (i < list.length - 1) s += e.after ?? rest;
    });
    return Math.round(s / 60);
  };
  const plural = (n, one, many) => `${n} ${n === 1 ? one : many}`;

  /* ---------- Screens ---------- */

  const screens = {
    dossier: document.querySelector('[data-screen="dossier"]'),
    builder: document.querySelector('[data-screen="builder"]'),
  };
  const parts = (s) => ({
    appbar: s.querySelector('.appbar'),
    body: s.querySelector('.body'),
    nav: s.querySelector('.nav'),
    toast: s.querySelector('.toast-host'),
    layer: s.querySelector('.sheet-layer'),
  });

  const NAV = {
    trainer: [['home', 'Home'], ['people', 'Members'], ['plans', 'Plans'], ['calendar', 'Schedule'], ['user', 'Profile']],
    admin: [['gauge', 'Dashboard'], ['card', 'Memberships'], ['wallet', 'Payments'], ['dots', 'More']],
  };
  const navHtml = (set, current) =>
    NAV[set]
      .map(
        ([i, l]) =>
          `<a href="#" data-act="nav" data-msg="Opens ${l}"${l === current ? ' aria-current="page"' : ''}><span class="pill">${ico(i)}</span><span class="lbl">${l}</span></a>`,
      )
      .join('');

  function paint(name, opts = {}) {
    const s = screens[name];
    const ps = parts(s);
    const top = ps.body.scrollTop;
    const view = name === 'dossier' ? dossierView() : builderView();
    ps.appbar.innerHTML = view.appbar;
    ps.body.innerHTML = view.body;
    ps.nav.innerHTML = view.nav;
    ps.body.scrollTop = opts.top ? 0 : top;
    ps.appbar.classList.toggle('scrolled', ps.body.scrollTop > 4);
    if (opts.enter) {
      ps.body.classList.remove('enter');
      void ps.body.offsetWidth;
      ps.body.classList.add('enter');
      clearTimeout(s._enterTimer);
      s._enterTimer = setTimeout(() => ps.body.classList.remove('enter'), 1000);
    }
  }

  function paintAppbar(name) {
    const view = name === 'dossier' ? dossierView() : builderView();
    parts(screens[name]).appbar.innerHTML = view.appbar;
  }

  /* ---------- Dossier view ---------- */

  function dossierView() {
    const admin = prefs.role === 'admin';
    const loaded = prefs.load === 'loaded';
    const editBtn = !loaded
      ? ''
      : D.editing
        ? `<button class="icon-btn" data-act="d-cancel" aria-label="Cancel">${ico('close')}</button>`
        : `<button class="icon-btn" data-act="d-edit" aria-label="Edit profile">${ico('edit')}</button>`;
    const appbar = `
      <button class="icon-btn" data-act="toast" data-msg="Back to Members" aria-label="Back">${ico('back')}</button>
      <div class="appbar-title"><span class="t">Member</span></div>
      ${editBtn}`;
    const nav = admin ? navHtml('admin', 'More') : navHtml('trainer', 'Members');

    let body;
    if (prefs.load === 'loading') body = dossierSkeleton();
    else if (prefs.load === 'error') body = errorView();
    else body = dossierBody(admin);
    return { appbar, body, nav };
  }

  function dossierBody(admin) {
    const who = people();
    const hasPt = prefs.pt === 'active';
    const fullName = prefs.long === 'on' ? who.member : `${D.first} ${D.last}`.trim();
    const email = D.emailOverride ?? who.email;

    const hero = `
      <section class="hero ${rise(1)}" aria-label="Membership">
        <span class="nia-anchor">${nia('Nia, breathing with this membership')}</span>
        <div class="hero-top">
          <p style="margin:0"><span class="fig">23</span><span class="fig-unit">days left</span></p>
          <span class="chip ok">Active</span>
        </div>
        <p class="hero-next">Quarterly Gold ends 3 Nov 2026</p>
        <div class="under">
          <div><span class="stat-n due-ink">₹2,450</span><span class="stat-l">Balance due</span></div>
          <div><span class="stat-n">7</span><span class="stat-l">Visits this month</span></div>
        </div>
        <p class="hero-foot">Last check-in yesterday at 6:48 AM</p>
        ${admin ? `<button class="btn tonal block" data-act="toast" data-msg="Opens Sell / assign membership">Sell or assign membership</button>` : ''}
      </section>`;

    const note = D.notes ? `<p class="note ${rise(2)}">${ico('alert', 'sm')}<span>${esc(D.notes)}</span></p>` : '';

    const pt = hasPt
      ? `
      <section class="block ${rise(3)}" aria-labelledby="h-pt">
        <header class="block-h"><h2 id="h-pt">Personal training</h2><span class="chip ok">Active</span></header>
        <div class="surface">
          <div class="trainer">
            <div class="avatar sm brand" aria-hidden="true">RM</div>
            <div class="txt"><span class="t">${esc(who.trainer)}</span><span class="s">Assigned trainer</span></div>
            ${admin ? `<button class="btn text sm" data-act="toast" data-msg="Opens Change trainer or slot">Change</button>` : ''}
          </div>
          <dl class="facts">
            <div><dt>Package</dt><dd>PT 12 sessions</dd></div>
            <div><dt>Slot</dt><dd>Mon, Wed, Fri at <span class="nw">7:00 AM</span></dd></div>
            <div><dt>Period</dt><dd class="num">1 to 31 Oct 2026<span class="dim">, 20 days left</span></dd></div>
            <div><dt>Next session</dt><dd>Upper body, tomorrow at <span class="nw">7:00 AM</span></dd></div>
          </dl>
          <div class="sessions">
            <div class="sessions-h"><span>Sessions used</span><span class="num"><b>4</b> of 12</span></div>
            <div class="meter" role="meter" aria-valuemin="0" aria-valuemax="12" aria-valuenow="4" aria-label="Sessions used"><i style="width:33.3%"></i></div>
          </div>
        </div>
        ${admin
          ? `<button class="btn outline block" data-act="d-renew">Renew personal training</button>`
          : `<button class="btn filled block" data-act="toast" data-msg="Opens Active workout for ${esc(who.memberShort)}">${ico('play')} Start workout session</button>`}
      </section>`
      : `
      <section class="block ${rise(3)}" aria-labelledby="h-pt">
        <header class="block-h"><h2 id="h-pt">Personal training</h2><span class="chip plain">Not purchased</span></header>
        <div class="surface voice">
          ${nia('Nia')}
          <div><p class="v1">No personal training yet.</p><p class="v2">Workout and diet plans open once a package starts.</p></div>
        </div>
        <button class="btn tonal block" data-act="toast" data-msg="Opens Add personal training">${ico('plus')} Add personal training</button>
      </section>`;

    const coaching = `
      <section class="block ${rise(4)}" aria-labelledby="h-coach">
        <header class="block-h"><h2 id="h-coach">Coaching</h2></header>
        <div class="list">
          ${row('target', 'Goals & progress', '2 goals, 1 on track', 'toast', 'Opens Goals & progress')}
          ${hasPt ? row('dumbbell', 'Workout plan', 'Hypertrophy block A, week 2 of 6', 'go-builder') : ''}
          ${hasPt ? row('bowl', 'Diet plan', '1,850 kcal a day, high protein', 'toast', 'Opens Diet plan') : ''}
        </div>
      </section>`;

    const contact = D.editing
      ? `
      <section class="block" id="d-form" aria-labelledby="h-contact">
        <header class="block-h"><h2 id="h-contact">Edit profile</h2></header>
        <div class="grid2">
          <div class="field tight ${D.firstError ? 'err' : ''}"><label for="f-first">First name</label><input id="f-first" class="input" data-bind="d.first" value="${esc(D.first)}" autocomplete="off"></div>
          <div class="field tight"><label for="f-last">Last name</label><input id="f-last" class="input" data-bind="d.last" value="${esc(D.last)}" autocomplete="off"></div>
        </div>
        ${D.firstError ? `<p class="err-msg" style="margin:6px 0 0">${ico('alert', 'sm')}First name is required.</p>` : ''}
        <div class="field" style="margin-top:14px"><label for="f-email">Email</label><input id="f-email" class="input" type="email" data-bind="d.email" value="${esc(email)}"></div>
        <div class="field"><label for="f-phone">Phone</label><input id="f-phone" class="input num" type="tel" data-bind="d.phone" value="${esc(D.phone)}"></div>
        <div class="field"><span class="lbl" id="f-gender">Gender</span>
          <div class="segm" role="group" aria-labelledby="f-gender">
            ${['Male', 'Female'].map((g) => `<button type="button" data-act="d-gender" data-v="${g}" aria-pressed="${D.gender === g}">${g}</button>`).join('')}
          </div>
        </div>
        <div class="field"><label for="f-notes">Notes</label><textarea id="f-notes" class="input" rows="3" data-bind="d.notes">${esc(D.notes)}</textarea></div>
        <button class="btn filled block" data-act="d-save">Save</button>
      </section>`
      : `
      <section class="block ${rise(5)}" aria-labelledby="h-contact">
        <header class="block-h"><h2 id="h-contact">Contact</h2></header>
        <div class="list">
          ${row('mail', email, 'Email', 'toast', 'Opens mail')}
          ${row('phone', D.phone, 'Phone', 'toast', 'Calls ' + D.phone)}
          ${row('gender', D.gender, 'Gender', null)}
        </div>
      </section>`;

    const records = `
      <section class="block ${rise(6)}" aria-labelledby="h-rec">
        <header class="block-h"><h2 id="h-rec">Records</h2></header>
        <div class="list">
          ${row('heart', 'Health', 'B+, 168 cm, 61 kg baseline', 'toast', 'Opens Health')}
          ${row('pulse', 'Medical history', '2 records, cleared for training', 'toast', 'Opens Medical history')}
          ${row('sos', 'Emergency contacts', 'Vikram Raghunathan, brother', 'toast', 'Opens Emergency contacts')}
          ${row('doc', 'Documents', '3 files', 'toast', 'Opens Documents')}
          ${row('image', 'Photos & avatar', '5 photos', 'toast', 'Opens Photos & avatar')}
        </div>
      </section>`;

    return `
      <header class="ident ${rise(0)}">
        <div class="avatar" aria-hidden="true">${who.memberInit}</div>
        <div style="min-width:0"><h1>${esc(fullName)}</h1><p class="num">LK-02417, member since March 2025</p></div>
      </header>
      ${hero}${note}${pt}${coaching}${contact}${records}`;
  }

  function row(icon, title, sub, act, msg) {
    const tag = act ? 'button' : 'div';
    const attrs = act ? ` type="button" data-act="${act}"${msg ? ` data-msg="${esc(msg)}"` : ''}` : '';
    return `<${tag} class="row"${attrs}>
      <span class="lead">${ico(icon)}</span>
      <span class="txt"><span class="t">${esc(title)}</span><span class="s">${esc(sub)}</span></span>
      ${act ? `<span class="trail">${ico('chev', 'sm')}</span>` : ''}
    </${tag}>`;
  }

  function dossierSkeleton() {
    const line = (w, h = 12) => `<div class="sk" style="width:${w};height:${h}px"></div>`;
    return `
      <div role="status" aria-label="Loading member">
        <div class="sk-row" style="margin:4px 0 26px"><div class="sk" style="width:52px;height:52px;border-radius:16px"></div><div class="sk-lines">${line('70%', 18)}${line('45%')}</div></div>
        <div class="sk" style="height:220px;border-radius:20px"></div>
        <div style="margin:30px 0 12px">${line('40%', 14)}</div>
        <div class="sk" style="height:196px;border-radius:16px"></div>
        <div style="margin:30px 0 12px">${line('30%', 14)}</div>
        <div class="sk" style="height:186px;border-radius:16px"></div>
      </div>`;
  }

  function errorView() {
    return `
      <div class="state-view" role="alert">
        <div class="state-ico">${ico('alert')}</div>
        <h3>This member didn't load.</h3>
        <p>The server didn't answer. Check the connection, then try again.</p>
        <button class="btn filled" data-act="d-retry">Retry</button>
      </div>`;
  }

  /* ---------- Builder view ---------- */

  function builderView() {
    const appbar = `
      <button class="icon-btn" data-act="b-back" aria-label="Back">${ico('back')}</button>
      <div class="appbar-title"><span class="t">Edit workout plan</span>${B.dirty ? '<span class="s">Unsaved changes</span>' : ''}</div>
      ${B.saving
        ? `<span class="spin" role="status" aria-label="Saving"></span>`
        : `<button class="btn text sm" data-act="b-save">Save</button><button class="btn filled sm" data-act="b-publish">Publish</button>`}`;
    return { appbar, body: builderBody(), nav: navHtml('trainer', 'Plans') };
  }

  function builderBody() {
    const who = people();
    const days = dayList();
    const list = exOf(B.day);
    const sets = list.reduce((n, e) => n + e.sets, 0);
    const statusChip = B.status === 'Active' ? '<span class="chip ok">Active</span>' : '<span class="chip draft">Draft</span>';

    const head = B.template
      ? ''
      : `
      <section class="member-head surface ${rise(0)}" aria-label="Member">
        <div class="avatar sm" aria-hidden="true">${who.memberInit}</div>
        <div class="txt"><span class="t">${esc(who.member)}</span><span class="s">Trainer: ${esc(who.trainer)}</span></div>
        ${statusChip}
      </section>
      ${D.notes ? `<p class="note ${rise(1)}">${ico('alert', 'sm')}<span>${esc(D.notes)}</span></p>` : ''}`;

    const title = `
      <div class="field title-field ${B.titleError ? 'err' : ''} ${rise(2)}">
        <label for="b-title">Title</label>
        <input id="b-title" class="input big" data-bind="b.title" value="${esc(B.title)}" autocomplete="off" ${B.titleError ? 'aria-invalid="true" aria-describedby="b-title-err"' : ''}>
        ${B.titleError ? `<span class="err-msg" id="b-title-err">${ico('alert', 'sm')}Title is required</span>` : ''}
      </div>`;

    const details = `
      <section class="details surface ${rise(3)}">
        <button class="details-h" data-act="b-details" aria-expanded="${B.detailsOpen}" aria-controls="b-details">
          <span class="details-sum">
            ${B.template ? '<span class="chip plain">Template</span>' : ''}
            <span class="chip plain">${esc(B.goal || 'No target goal')}</span>
            <span class="chip plain">${esc(B.difficulty || 'No difficulty')}</span>
            <span class="chip plain num">${plural(B.weeks, 'week', 'weeks')}</span>
          </span>
          ${ico('chevDown')}
        </button>
        ${B.detailsOpen ? `
        <div class="details-b" id="b-details">
          <div class="field"><label for="b-desc">Description</label><textarea id="b-desc" class="input" rows="3" data-bind="b.description">${esc(B.description)}</textarea></div>
          <div class="field"><label for="b-goal">Target goal</label><input id="b-goal" class="input" data-bind="b.goal" value="${esc(B.goal)}"></div>
          <div class="field"><span class="lbl" id="b-diff">Difficulty</span>
            <div class="segm" role="group" aria-labelledby="b-diff">
              ${['Beginner', 'Intermediate', 'Advanced'].map((d) => `<button type="button" data-act="b-diff" data-v="${d}" aria-pressed="${B.difficulty === d}">${d}</button>`).join('')}
            </div>
          </div>
          <div class="field"><span class="lbl" id="b-weeks">Duration</span>
            <div class="stepper weeks" role="group" aria-labelledby="b-weeks">
              <button type="button" data-act="b-weeks" data-d="-1" aria-label="One week fewer" ${B.weeks <= 1 ? 'disabled' : ''}>${ico('minus')}</button>
              <output aria-live="polite"><b class="num">${B.weeks}</b>${B.weeks === 1 ? 'week' : 'weeks'}</output>
              <button type="button" data-act="b-weeks" data-d="1" aria-label="One week more" ${B.weeks >= 52 ? 'disabled' : ''}>${ico('plus')}</button>
            </div>
          </div>
          <div class="switch">
            <div class="txt"><span class="t" id="b-tpl">Template</span><span class="s">A reusable plan with no member</span></div>
            <button type="button" class="tog" role="switch" aria-checked="${B.template}" aria-labelledby="b-tpl" data-act="b-template"></button>
          </div>
        </div>` : ''}
      </section>`;

    const tabs = `
      <div class="sec-h ${rise(4)}"><h2>Days</h2><span class="num">${plural(B.exercises.length, 'exercise', 'exercises')} in all</span></div>
      <div class="days ${rise(5)}" role="tablist" aria-label="Plan days">
        ${days.map((d) => {
          const n = exOf(d).length;
          return `<button type="button" class="day press" role="tab" aria-selected="${d === B.day}" data-act="b-day" data-day="${d}">
            <span class="d">Day ${d}</span><span class="c">${n ? plural(n, 'exercise', 'exercises') : 'Empty'}</span></button>`;
        }).join('')}
        <button type="button" class="day add press" data-act="b-addday" aria-label="Add day ${maxDay() + 1}">${ico('plus', 'sm')}<span class="d">Day</span></button>
      </div>`;

    if (!list.length) {
      return `${head}${title}${details}${tabs}
        <section class="empty ${rise(6)}" aria-live="polite">
          ${nia('Nia')}
          <h3>Day ${B.day} is empty.</h3>
          <p>Add the first exercise. A day with no exercises isn't saved.</p>
          <button class="btn filled" data-act="b-pick">${ico('plus')} Add exercise</button>
        </section>`;
    }

    const cards = list
      .map((e, i) => {
        const open = B.open === e.id;
        const restChips = [45, 60, 90, 120, 180]
          .map((s) => `<button type="button" class="pick" data-act="b-rest" data-id="${e.id}" data-v="${s}" aria-pressed="${(e.rest ?? DEFAULT_REST) === s}">${s}s</button>`)
          .join('');
        const afterChips = [['Same', null], ['60s', 60], ['90s', 90], ['120s', 120], ['180s', 180]]
          .map(([l, v]) => `<button type="button" class="pick" data-act="b-after" data-id="${e.id}" data-v="${v ?? ''}" aria-pressed="${(e.after ?? null) === v}">${l}</button>`)
          .join('');
        return `
        <li class="ex${open ? ' open' : ''}${B.justAdded === e.id ? ' just-added' : ''}" data-ex="${e.id}">
          <button type="button" class="ex-head" data-act="b-open" data-id="${e.id}" aria-expanded="${open}">
            <span class="ord">${i + 1}</span>
            <span class="ex-txt"><span class="ex-name">${esc(e.name)}</span><span class="ex-sum">${esc(summary(e))}</span></span>
            <span class="grip" title="Drag to reorder">${ico('grip')}</span>
          </button>
          ${open ? `
          <div class="ex-body">
            <div class="grid2">
              <div class="field tight"><span class="lbl">Sets</span>
                <div class="stepper">
                  <button type="button" data-act="b-sets" data-id="${e.id}" data-d="-1" aria-label="Fewer sets" ${e.sets <= 1 ? 'disabled' : ''}>${ico('minus')}</button>
                  <output class="num" aria-live="polite">${e.sets}</output>
                  <button type="button" data-act="b-sets" data-id="${e.id}" data-d="1" aria-label="More sets" ${e.sets >= 10 ? 'disabled' : ''}>${ico('plus')}</button>
                </div>
              </div>
              <div class="field tight"><label for="reps-${e.id}">Reps</label><input id="reps-${e.id}" class="input num" data-bind="b.reps" data-id="${e.id}" value="${esc(e.reps)}" placeholder="8–10"></div>
              <div class="field tight span2"><span class="lbl">Weight (kg)</span>
                <div class="stepper">
                  <button type="button" data-act="b-kg" data-id="${e.id}" data-d="-2.5" aria-label="Less weight" ${e.kg == null ? 'disabled' : ''}>${ico('minus')}</button>
                  <output class="num" aria-live="polite">${e.kg == null ? 'Bodyweight' : fmtKg(e.kg) + ' kg'}</output>
                  <button type="button" data-act="b-kg" data-id="${e.id}" data-d="2.5" aria-label="More weight">${ico('plus')}</button>
                </div>
              </div>
            </div>
            <div class="field tight"><span class="lbl">Rest between sets</span><div class="chips">${restChips}</div></div>
            <div class="field tight"><span class="lbl">Rest before the next exercise</span><div class="chips">${afterChips}</div></div>
            <div class="ex-actions">
              <button type="button" class="icon-btn" data-act="b-move" data-id="${e.id}" data-d="-1" aria-label="Move up" ${i === 0 ? 'disabled' : ''}>${ico('up', 'sm')}</button>
              <button type="button" class="icon-btn" data-act="b-move" data-id="${e.id}" data-d="1" aria-label="Move down" ${i === list.length - 1 ? 'disabled' : ''}>${ico('down', 'sm')}</button>
              <button type="button" class="btn text sm" data-act="b-moveday" data-id="${e.id}">${ico('swap')}Move to day</button>
              <button type="button" class="btn text sm danger" data-act="b-remove" data-id="${e.id}">${ico('trash')}Remove</button>
            </div>
          </div>` : ''}
        </li>`;
      })
      .join('');

    return `${head}${title}${details}${tabs}
      <div class="dayhero ${rise(6)}">
        <div><span class="fig">${sets}</span><span class="fig-unit">sets on Day ${B.day}</span>
        <p class="hero-next num">${plural(list.length, 'exercise', 'exercises')}, about ${dayMinutes(list)} min</p></div>
      </div>
      <ol class="ex-list ${rise(7)}" aria-label="Day ${B.day} exercises">${cards}</ol>
      <button type="button" class="add-ex ${rise(8)}" data-act="b-pick">${ico('plus')}Add exercise to Day ${B.day}</button>`;
  }

  /* ---------- Toast and sheet ---------- */

  function toast(name, text, action) {
    const host = parts(screens[name]).toast;
    clearTimeout(host._timer);
    host.innerHTML = `<div class="toast" role="status"><span>${esc(text)}</span>${action ? `<button type="button" class="btn text sm" data-toast-act>${esc(action.label)}</button>` : ''}</div>`;
    const el = host.firstElementChild;
    requestAnimationFrame(() => el.classList.add('show'));
    if (action) el.querySelector('[data-toast-act]').addEventListener('click', () => { action.run(); hideToast(host); });
    host._timer = setTimeout(() => hideToast(host), action ? 5000 : 2800);
  }
  function hideToast(host) {
    const el = host.firstElementChild;
    if (!el) return;
    el.classList.remove('show');
    setTimeout(() => { if (host.firstElementChild === el) host.innerHTML = ''; }, 260);
  }

  let openSheetName = null;
  function openSheet(name, title, inner, onMount) {
    const layer = parts(screens[name]).layer;
    layer.innerHTML = `
      <div class="scrim" data-act="sheet-close"></div>
      <div class="sheet" role="dialog" aria-modal="true" aria-label="${esc(title)}">
        <div class="grab" aria-hidden="true"></div>
        <div class="sheet-h"><h3>${esc(title)}</h3><button class="icon-btn" data-act="sheet-close" aria-label="Close">${ico('close')}</button></div>
        ${inner}
      </div>`;
    openSheetName = name;
    requestAnimationFrame(() => {
      layer.classList.add('open');
      if (onMount) onMount(layer);
      else layer.querySelector('.sheet-h .icon-btn').focus({ preventScroll: true });
    });
  }
  function closeSheet(name, after) {
    const layer = parts(screens[name]).layer;
    layer.classList.remove('open');
    openSheetName = null;
    if (after) after();
    setTimeout(() => { if (!layer.classList.contains('open')) layer.innerHTML = ''; }, 340);
  }

  /* ---------- Builder sheets ---------- */

  function pickerList() {
    const q = B.pickQuery.trim().toLowerCase();
    const items = LIBRARY.filter(([n, m]) => (B.pickMuscle === 'All' || m === B.pickMuscle) && (!q || n.toLowerCase().includes(q)));
    if (!items.length) return `<p class="pick-empty">No exercises match. Try a shorter search or another muscle group.</p>`;
    return `<div class="list">${items
      .map(([n, m, eq]) => {
        const already = exOf(B.pickDay).some((e) => e.name === n);
        return `<button type="button" class="row" data-act="b-add" data-name="${esc(n)}">
          <span class="lead">${ico('dumbbell')}</span>
          <span class="txt"><span class="t">${esc(n)}</span><span class="s">${m}, ${eq}${already ? ', already on this day' : ''}</span></span>
          <span class="trail">${ico('plus', 'sm')}</span></button>`;
      })
      .join('')}</div>`;
  }

  function openPicker(day) {
    B.pickDay = day;
    B.pickQuery = '';
    B.pickMuscle = 'All';
    const inner = `
      <div class="sheet-tools">
        <div class="search">${ico('search', 'sm')}<input class="input" type="search" placeholder="Search exercises" aria-label="Search exercises" data-pick-q autocomplete="off"></div>
        <div class="chips scroll" role="group" aria-label="Muscle group">
          ${MUSCLES.map((m) => `<button type="button" class="pick" data-act="b-muscle" data-v="${m}" aria-pressed="${m === 'All'}">${m}</button>`).join('')}
        </div>
      </div>
      <div class="sheet-b" data-pick-list>${pickerList()}</div>`;
    openSheet('builder', `Add to Day ${day}`, inner, (layer) => layer.querySelector('[data-pick-q]').focus({ preventScroll: true }));
  }

  function refreshPicker() {
    const layer = parts(screens.builder).layer;
    const listEl = layer.querySelector('[data-pick-list]');
    if (listEl) listEl.innerHTML = pickerList();
    layer.querySelectorAll('[data-act="b-muscle"]').forEach((b) => b.setAttribute('aria-pressed', String(b.dataset.v === B.pickMuscle)));
  }

  function openMoveDay(id) {
    const e = B.exercises.find((x) => x.id === id);
    const targets = [...new Set(B.exercises.map((x) => x.day))].filter((d) => d !== e.day).sort((a, b) => a - b);
    const next = maxDay() + 1;
    const inner = `
      <div class="sheet-b">
        <p>Move <strong>${esc(e.name)}</strong> from Day ${e.day}. It goes to the end of the day you pick.</p>
        <div class="list">
          ${targets.map((d) => `<button type="button" class="row" data-act="b-moveto" data-id="${id}" data-day="${d}">
            <span class="lead"><span class="ord" style="width:auto">${d}</span></span>
            <span class="txt"><span class="t">Day ${d}</span><span class="s">${plural(exOf(d).length, 'exercise', 'exercises')}</span></span>
            <span class="trail">${ico('chev', 'sm')}</span></button>`).join('')}
          <button type="button" class="row" data-act="b-moveto" data-id="${id}" data-day="${next}">
            <span class="lead">${ico('plus')}</span>
            <span class="txt"><span class="t">New Day ${next}</span><span class="s">Starts a new day with this exercise</span></span>
            <span class="trail">${ico('chev', 'sm')}</span></button>
        </div>
      </div>`;
    openSheet('builder', 'Move to day', inner);
  }

  function openDiscard() {
    const inner = `
      <div class="sheet-b">
        <p>You have unsaved changes to ${esc(B.title || 'this plan')}. Leaving now discards them.</p>
        <div class="sheet-actions">
          <button class="btn filled block" data-act="sheet-close">Keep editing</button>
          <button class="btn outline block" data-act="b-discard" style="color:var(--bad)">Discard changes</button>
        </div>
      </div>`;
    openSheet('builder', 'Discard changes?', inner);
  }

  /* ---------- Dossier sheets ---------- */

  function openRenew() {
    const who = people();
    D.renewMethod = null;
    const inner = `
      <div class="sheet-b">
        <p>Renew PT 12 sessions with ${esc(who.trainer)} on Mon, Wed, Fri at 7:00 AM. The new period starts 1 Nov 2026.</p>
        <div class="field"><span class="lbl" id="r-method">Payment method</span>
          <div class="chips" role="group" aria-labelledby="r-method">
            ${['UPI', 'Card', 'Cash', 'Bank transfer'].map((m) => `<button type="button" class="pick" data-act="d-method" data-v="${m}" aria-pressed="false">${m}</button>`).join('')}
          </div>
        </div>
        <div class="sheet-actions"><button class="btn filled block" data-act="d-renew-ok" disabled>Renew</button></div>
      </div>`;
    openSheet('dossier', 'Renew personal training', inner);
  }

  /* ---------- Builder mutations ---------- */

  function touch() {
    if (!B.dirty) {
      B.dirty = true;
      paintAppbar('builder');
    }
  }
  const findEx = (id) => B.exercises.find((e) => e.id === Number(id));

  function scrollToEx(id) {
    requestAnimationFrame(() => {
      const el = screens.builder.querySelector(`[data-ex="${id}"]`);
      if (el) el.scrollIntoView({ block: 'nearest', behavior: prefs.motion === 'on' ? 'smooth' : 'auto' });
    });
  }

  function saveBuilder(andPublish) {
    if (!B.title.trim()) {
      B.titleError = true;
      paint('builder', { top: true });
      screens.builder.querySelector('#b-title').focus({ preventScroll: true });
      return;
    }
    B.saving = true;
    paintAppbar('builder');
    setTimeout(() => {
      B.saving = false;
      B.dirty = false;
      if (andPublish) B.status = 'Active';
      snapshot = JSON.stringify({ ...B, exercises: B.exercises });
      paint('builder');
      toast('builder', andPublish ? 'Plan published' : 'Plan saved');
    }, 900);
  }

  /* ---------- Actions ---------- */

  const actions = {
    toast: (el, name) => toast(name, el.dataset.msg),
    nav: (el, name) => toast(name, el.dataset.msg),
    'sheet-close': (el, name) => closeSheet(name),

    'd-edit': () => { D.editing = true; D.firstError = false; paint('dossier'); requestAnimationFrame(() => { const f = screens.dossier.querySelector('#d-form'); f.scrollIntoView({ block: 'start', behavior: prefs.motion === 'on' ? 'smooth' : 'auto' }); f.querySelector('input').focus({ preventScroll: true }); }); },
    'd-cancel': () => { D.editing = false; D.firstError = false; paint('dossier'); },
    'd-gender': (el) => { D.gender = el.dataset.v; el.parentElement.querySelectorAll('button').forEach((b) => b.setAttribute('aria-pressed', String(b === el))); },
    'd-save': () => {
      if (!D.first.trim()) { D.firstError = true; paint('dossier'); screens.dossier.querySelector('#f-first').focus(); return; }
      D.editing = false; D.firstError = false;
      paint('dossier');
      toast('dossier', 'Profile saved.');
    },
    'd-renew': () => openRenew(),
    'd-method': (el) => {
      D.renewMethod = el.dataset.v;
      const layer = parts(screens.dossier).layer;
      layer.querySelectorAll('[data-act="d-method"]').forEach((b) => b.setAttribute('aria-pressed', String(b === el)));
      layer.querySelector('[data-act="d-renew-ok"]').disabled = false;
    },
    'd-renew-ok': () => closeSheet('dossier', () => toast('dossier', `Personal training renewed. Paid by ${D.renewMethod}.`)),
    'd-retry': () => {
      setPref('load', 'loading');
      setTimeout(() => setPref('load', 'loaded'), 1100);
    },
    'go-builder': () => {
      if (narrow.matches) setPref('view', 'builder');
      const panel = document.querySelector('[data-panel="builder"]');
      panel.scrollIntoView({ behavior: prefs.motion === 'on' ? 'smooth' : 'auto', block: 'center' });
      panel.classList.remove('flash'); void panel.offsetWidth; panel.classList.add('flash');
    },

    'b-back': () => (B.dirty ? openDiscard() : toast('builder', 'Back to Workout plans')),
    'b-discard': () => closeSheet('builder', () => {
      const saved = JSON.parse(snapshot);
      Object.assign(B, saved, { dirty: false, titleError: false, open: null, day: 1, justAdded: null });
      paint('builder', { top: true });
      toast('builder', 'Changes discarded');
    }),
    'b-save': () => saveBuilder(false),
    'b-publish': () => saveBuilder(true),
    'b-details': () => { B.detailsOpen = !B.detailsOpen; paint('builder'); },
    'b-diff': (el) => { B.difficulty = el.dataset.v; touch(); paint('builder'); },
    'b-weeks': (el) => { B.weeks = Math.min(52, Math.max(1, B.weeks + Number(el.dataset.d))); touch(); paint('builder'); },
    'b-template': () => { B.template = !B.template; touch(); paint('builder'); },
    'b-day': (el) => { B.day = Number(el.dataset.day); B.open = null; B.justAdded = null; paint('builder'); },
    'b-addday': () => { B.day = maxDay() + 1; B.open = null; paint('builder'); openPicker(B.day); },
    'b-pick': () => openPicker(B.day),
    'b-muscle': (el) => { B.pickMuscle = el.dataset.v; refreshPicker(); },
    'b-add': (el) => {
      const e = ex(el.dataset.name, B.pickDay, 3, '10', null, null);
      B.exercises.push(e);
      B.day = B.pickDay; B.open = e.id; B.justAdded = e.id;
      touch();
      closeSheet('builder');
      paint('builder');
      scrollToEx(e.id);
      toast('builder', `Added ${e.name} to Day ${e.day}`);
    },
    'b-open': (el) => { const id = Number(el.dataset.id); B.open = B.open === id ? null : id; B.justAdded = null; paint('builder'); if (B.open) scrollToEx(id); },
    'b-sets': (el) => { const e = findEx(el.dataset.id); e.sets = Math.min(10, Math.max(1, e.sets + Number(el.dataset.d))); touch(); paint('builder'); },
    'b-kg': (el) => {
      const e = findEx(el.dataset.id);
      const next = (e.kg ?? 0) + Number(el.dataset.d);
      e.kg = next <= 0 ? null : next;
      touch(); paint('builder');
    },
    'b-rest': (el) => { const e = findEx(el.dataset.id); const v = Number(el.dataset.v); e.rest = v === DEFAULT_REST ? null : v; touch(); paint('builder'); },
    'b-after': (el) => { const e = findEx(el.dataset.id); e.after = el.dataset.v === '' ? null : Number(el.dataset.v); touch(); paint('builder'); },
    'b-move': (el) => {
      const e = findEx(el.dataset.id);
      const list = exOf(e.day);
      const i = list.indexOf(e);
      const j = i + Number(el.dataset.d);
      if (j < 0 || j >= list.length) return;
      const a = B.exercises.indexOf(list[i]);
      const b = B.exercises.indexOf(list[j]);
      [B.exercises[a], B.exercises[b]] = [B.exercises[b], B.exercises[a]];
      touch(); paint('builder'); scrollToEx(e.id);
    },
    'b-moveday': (el) => openMoveDay(Number(el.dataset.id)),
    'b-moveto': (el) => {
      const e = findEx(el.dataset.id);
      const from = e.day;
      const to = Number(el.dataset.day);
      B.exercises.splice(B.exercises.indexOf(e), 1);
      e.day = to;
      B.exercises.push(e);
      if (!exOf(from).length) B.day = to;
      B.open = null;
      touch();
      closeSheet('builder');
      paint('builder');
      toast('builder', `Moved to Day ${to}`, { label: 'View', run: () => { B.day = to; B.open = e.id; paint('builder'); scrollToEx(e.id); } });
    },
    'b-remove': (el) => {
      const e = findEx(el.dataset.id);
      const at = B.exercises.indexOf(e);
      B.exercises.splice(at, 1);
      B.open = null;
      touch(); paint('builder');
      toast('builder', `Removed ${e.name}`, {
        label: 'Undo',
        run: () => { B.exercises.splice(at, 0, e); B.day = e.day; B.open = e.id; paint('builder'); scrollToEx(e.id); },
      });
    },
  };

  document.addEventListener('click', (ev) => {
    const el = ev.target.closest('[data-act]');
    if (!el) return;
    const screen = el.closest('[data-screen]');
    if (!screen) return;
    if (el.tagName === 'A') ev.preventDefault();
    const fn = actions[el.dataset.act];
    if (fn) fn(el, screen.dataset.screen);
  });

  document.addEventListener('input', (ev) => {
    const el = ev.target;
    if (el.matches('[data-pick-q]')) {
      B.pickQuery = el.value;
      refreshPicker();
      return;
    }
    const bind = el.dataset.bind;
    if (!bind) return;
    const [scope, key] = bind.split('.');
    if (scope === 'd') {
      if (key === 'email') D.emailOverride = el.value;
      else D[key] = el.value;
      return;
    }
    if (key === 'reps') {
      const e = findEx(el.dataset.id);
      e.reps = el.value;
      const sum = el.closest('.ex').querySelector('.ex-sum');
      if (sum) sum.textContent = summary(e);
    } else {
      B[key] = el.value;
      if (key === 'title' && B.titleError && el.value.trim()) {
        B.titleError = false;
        const field = el.closest('.field');
        field.classList.remove('err');
        field.querySelector('.err-msg')?.remove();
        el.removeAttribute('aria-invalid');
      }
    }
    touch();
  });

  document.addEventListener('keydown', (ev) => {
    if (ev.key === 'Escape' && openSheetName) closeSheet(openSheetName);
  });

  Object.values(screens).forEach((s) => {
    const ps = parts(s);
    ps.body.addEventListener('scroll', () => ps.appbar.classList.toggle('scrolled', ps.body.scrollTop > 4), { passive: true });
  });

  /* ---------- Review controls ---------- */

  const narrow = window.matchMedia('(max-width: 860px)');
  const root = document.documentElement;

  function applyChrome() {
    if (prefs.theme === 'system') delete root.dataset.theme;
    else root.dataset.theme = prefs.theme;
    root.dataset.motion = prefs.motion;
    root.style.setProperty('--screen-w', `${prefs.width}px`);
    document.querySelectorAll('[data-pref]').forEach((group) => {
      const key = group.dataset.pref;
      group.querySelectorAll('button').forEach((b) => b.setAttribute('aria-pressed', String(b.dataset.val === String(prefs[key]))));
    });
    document.querySelectorAll('[data-view]').forEach((b) => b.setAttribute('aria-selected', String(b.dataset.view === prefs.view)));
    document.querySelectorAll('[data-panel]').forEach((panel) => {
      panel.hidden = narrow.matches && panel.dataset.panel !== prefs.view;
    });
  }

  function setPref(key, value) {
    prefs[key] = value;
    if (persisted.includes(key)) store.set(key, value);
    applyChrome();
    if (key === 'role' || key === 'load' || key === 'pt') {
      if (key !== 'load') D.editing = false;
      paint('dossier', { enter: true, top: key === 'load' });
    }
    if (key === 'long') {
      paint('dossier');
      paint('builder');
    }
    if (key === 'view') {
      const name = value === 'dossier' ? 'dossier' : 'builder';
      paint(name, { enter: true });
    }
  }

  document.querySelectorAll('[data-pref]').forEach((group) => {
    group.addEventListener('click', (ev) => {
      const b = ev.target.closest('button[data-val]');
      if (b) setPref(group.dataset.pref, b.dataset.val);
    });
  });
  document.querySelectorAll('[data-view]').forEach((b) => b.addEventListener('click', () => setPref('view', b.dataset.view)));
  narrow.addEventListener('change', applyChrome);

  if (params.has('open')) B.open = Number(params.get('open'));
  if (params.has('day')) B.day = Number(params.get('day'));
  if (params.has('edit')) D.editing = true;

  applyChrome();
  paint('dossier', { enter: true });
  paint('builder', { enter: true });
  if (params.has('scroll')) {
    Object.values(screens).forEach((s) => { parts(s).body.scrollTop = Number(params.get('scroll')); });
  }
})();
