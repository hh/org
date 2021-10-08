// Load Testing

import http from "k6/http";
import { check, sleep } from "k6";

export let options = {
  stages: [{ duration: "10m", target: 1 * 1000 * 1000 }],
  maxRedirects: 0,
};

export default function () {
  let res = http.get("https://artifactserver.bobymcbobs.pair.sharing.io");
  check(res, { "status was 302": (r) => r.status == 302 });
  // console.log(JSON.stringify(res));
  sleep(1);
}
