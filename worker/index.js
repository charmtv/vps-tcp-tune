const GITHUB_RAW_BASE =
  "https://raw.githubusercontent.com/charmtv/vps-tcp-tune/main";
const RELEASE = "f1eebb2";

const ROUTES = new Map([
  ["/", "install-alias.sh"],
  ["/install-alias.sh", "install-alias.sh"],
  ["/net-tcp-tune.sh", "net-tcp-tune.sh"],
]);

const SCRIPT_HEADERS = {
  "access-control-allow-origin": "*",
  "cache-control": "no-cache",
  "content-disposition": "inline",
  "content-type": "text/plain; charset=utf-8",
  "x-content-type-options": "nosniff",
};

export default {
  async fetch(request) {
    if (request.method !== "GET" && request.method !== "HEAD") {
      return new Response("Method Not Allowed\n", {
        status: 405,
        headers: { allow: "GET, HEAD" },
      });
    }

    const url = new URL(request.url);
    if (url.pathname === "/health") {
      return Response.json(
        { ok: true, service: "milier-bbr-launcher", release: RELEASE },
        { headers: { "cache-control": "no-store" } },
      );
    }

    const filename = ROUTES.get(url.pathname);
    if (!filename) {
      return new Response("Not Found\n", { status: 404 });
    }

    const upstream = await fetch(`${GITHUB_RAW_BASE}/${filename}?v=${RELEASE}`, {
      headers: {
        accept: "text/plain",
        "user-agent": "milier-bbr-launcher/1.0",
      },
      cf: { cacheEverything: true, cacheTtl: 300 },
    });

    if (!upstream.ok || !upstream.body) {
      return new Response("Upstream unavailable\n", {
        status: 502,
        headers: { "cache-control": "no-store" },
      });
    }

    return new Response(request.method === "HEAD" ? null : upstream.body, {
      status: 200,
      headers: SCRIPT_HEADERS,
    });
  },
};
