

// Selecting data

package main


import (
	"fmt"
	"os"
	"database/sql"
	_ "github.com/lib/pq"
)

func main() {
	db, err := sql.Open("postgres", fmt.Sprintf("postgres://postgres:password@%v/peeringdb", os.Getenv("SHARINGIO_PAIR_LOAD_BALANCER_IP")))
	if err != nil {
		fmt.Println(err.Error())
		return
	}
	db.Ping()
	fmt.Println("Hello")
}
