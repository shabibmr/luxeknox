const BASE = 'http://127.0.0.1:3311/v1';
const [,, method, urlPath, bodyArg, tokenArg] = process.argv;
const opts = { method: method || 'GET', headers: { 'Content-Type': 'application/json' } };
if (tokenArg) opts.headers['Authorization'] = `Bearer ${tokenArg}`;
if (bodyArg) opts.body = bodyArg;
const res = await fetch(BASE + urlPath, opts);
const text = await res.text();
console.log('STATUS', res.status);
console.log(text);
