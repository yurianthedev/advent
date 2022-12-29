use std::{fs, vec};

fn main() {
    let contents = fs::read_to_string("year21/day07/input.txt").unwrap();
    let xs = contents.split(",").map(|x| x.parse::<usize>().unwrap());
    let max = xs.clone().max().unwrap();
    let mut positions = vec![0usize; max + 1];

    for x in xs {
        positions[x] += 1
    }

    let mut min_to_pos = vec![0usize; max + 1];

    for i in 0..=max {
        let mut for_each_pos = vec![0usize; max + 1];
        for (j, y) in positions.iter().enumerate() {
            for_each_pos[j] = y * com(j.abs_diff(i))
        }
        min_to_pos[i] = for_each_pos.iter().sum();
    }

    println!("{}", min_to_pos.iter().min().unwrap())
}

fn com(i: usize) -> usize {
    (i * (i + 1)) / 2
}
