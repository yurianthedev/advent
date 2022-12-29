fn main() {
    let mut calories: Vec<i32> = include_str!("sample-input.txt")
        .split("\n\n")
        .map(|elf| elf.lines().map(|cal| cal.parse::<i32>().unwrap()).sum())
        .collect();

    calories.sort();
    calories.reverse();
    println!("{:?}", calories.iter().take(3).sum::<i32>());
}
