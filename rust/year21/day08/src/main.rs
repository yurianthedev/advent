use std::collections::HashMap;
use utils::{InputBuilder, SolverBuilder};

fn main() {
    let input = InputBuilder::new(String::from("year21/day08"), 26)
        .second_ans(61229)
        .build();

    let digit_segments: HashMap<u8, u8> = HashMap::from([(1, 2), (4, 4), (7, 3), (8, 7)]);
    let to_find = [1, 4, 7, 8];
    let lens_to_find: Vec<u8> = to_find
        .iter()
        .map(|n| *digit_segments.get(n).unwrap())
        .collect();

    let solver = SolverBuilder::new(input, |input| first(input, &lens_to_find))
        .second_fn(second)
        .build();

    println!("{:?}", solver.solve());
}

fn first(input: String, lens_to_find: &[u8]) -> i32 {
    input.lines().fold(0, |count, line| {
        line.split('|')
            .map(|part| part.split_whitespace())
            .last()
            .unwrap()
            .fold(0, |c, w| {
                c + (lens_to_find.contains(&(w.len() as u8)) as i32)
            })
            + count
    })
}

fn second(input: String) -> i32 {
    input.lines().map(|line| {
        let mut parts = line.splitn(2, '|').map(|s| s.trim());
        let obs = parts.next().unwrap().split_whitespace();
        println!("{:?}", obs);
        todo!()
    });

    todo!()
}
