import assert from "node:assert/strict";
import worker from "../worker/index.js";

const originalFetch = globalThis.fetch;
const upstreamBody = "#!/usr/bin/env bash\nprintf 'ok\\n'\n";

globalThis.fetch = async (url) => {
  assert.match(String(url), /^https:\/\/raw\.githubusercontent\.com\//);
  return new Response(upstreamBody, {
    headers: { "content-type": "text/plain" },
  });
};

try {
  const root = await worker.fetch(new Request("https://bbr.813099.xyz/"));
  assert.equal(root.status, 200);
  assert.equal(await root.text(), upstreamBody);
  assert.match(root.headers.get("content-type"), /^text\/plain/);

  const script = await worker.fetch(
    new Request("https://bbr.813099.xyz/net-tcp-tune.sh"),
  );
  assert.equal(script.status, 200);

  const health = await worker.fetch(
    new Request("https://bbr.813099.xyz/health"),
  );
  assert.deepEqual(await health.json(), {
    ok: true,
    service: "milier-bbr-launcher",
    release: "f1eebb2",
  });

  const missing = await worker.fetch(
    new Request("https://bbr.813099.xyz/unknown"),
  );
  assert.equal(missing.status, 404);

  const method = await worker.fetch(
    new Request("https://bbr.813099.xyz/", { method: "POST" }),
  );
  assert.equal(method.status, 405);

  console.log("通过：Worker 路由与响应检查");
} finally {
  globalThis.fetch = originalFetch;
}
