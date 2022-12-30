package utility

import (
	"fmt"
	"io/ioutil"
	"strings"
)

func ReadInput(day string, example bool) ([]string, error) {
	var file string
	if example {
		file = "example.txt"
	} else {
		file = "input.txt"
	}

	path := fmt.Sprintf("%s/%s", day, file)
	content, err := ioutil.ReadFile(path)
	if err != nil {
		path = file
		content, err = ioutil.ReadFile(path)

		if err != nil {
			return nil, err
		}
	}

	data := strings.Split(string(content), "\n")

	return data, nil
}
