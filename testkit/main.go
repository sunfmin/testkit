package main

import (
	"fmt"
	"log"
	"net/http"
	"net/http/httputil"
	"os"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		es := os.Environ()
		fmt.Fprintf(w, "# ENV\n\n")
		for _, e := range es {
			fmt.Fprintf(w, "%s\n", e)
		}
		fmt.Fprintf(w, "\n\n\n")
		fmt.Fprintf(w, "# HTTP Request\n\n")
		b, err := httputil.DumpRequest(r, true)
		if err != nil {
			panic(err)
		}
		fmt.Fprintf(w, string(b))
	})
	port := os.Getenv("PORT")
	if len(port) == 0 {
		port = "4000"
	}
	log.Println("starting at :" + port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
