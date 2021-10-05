package main

import (
  "log"
  "net/http"
  "time"
  "os"

  "github.com/gorilla/mux"
)

// logging ...
// basic request logging middleware
func logging(next http.Handler) http.Handler {
  // log all requests
  return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
    log.Printf("%v %v %v %v %v/%v", r.Method, r.URL, r.Proto, r.Response, r.RemoteAddr, r.Header.Get("X-Real-Ip"))
    next.ServeHTTP(w, r)
  })
}

func decideHost(sourceIP string) string {
  // get asns (a large list)
  // use a BGP library to map out the route
  // use sourceIP to find the closest
    if sourceIP == os.Getenv("LOCAL_IP") {
      return "registry-1.docker.io"
    }
    return "k8s.gcr.io"
}

// getRoot ...
// get root of API
func getRoot(w http.ResponseWriter, r *http.Request) {
  host := decideHost(r.Header.Get("X-Real-Ip"))
  log.Println(host)
  w.WriteHeader(200)
  w.Write([]byte(host))
}

func main() {
  // bring up the API
  port := ":8080"
  router := mux.NewRouter()

  router.HandleFunc("/", getRoot)
  router.Use(logging)

  srv := &http.Server{
    Handler:      router,
    Addr:         port,
    WriteTimeout: 15 * time.Second,
    ReadTimeout:  15 * time.Second,
  }
  log.Println("Listening on", port)
  log.Fatal(srv.ListenAndServe())
}
