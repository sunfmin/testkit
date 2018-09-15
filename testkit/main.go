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
	log.Println("starting at :4000")
	log.Fatal(http.ListenAndServe(":4000", nil))
}
