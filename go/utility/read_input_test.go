package utility_test

import (
	"testing"

	"github.com/yurianxdev/advent-2020/utility"
)

func TestReadInput(t *testing.T) {
	day := "utility"
	expected := []string{"10", "20", "30"}
	got, err := utility.ReadInput(day, false)

	if err != nil {
		t.Errorf("error reading input: %v", err)
	}
	if len(got) != 3 {
		t.Errorf("expected: slice long 3; got: slice long %d", len(got))

		return
	}
	for i, val := range expected {
		if val != got[i] {
			t.Errorf("expected: %v; got: %s", expected, got)
		}
	}
}
