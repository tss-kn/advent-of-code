use std::env;
use std::fs::File;
use std::io::Read;
use std::path::Path;

use crate::column_iter::ColumnIter;
pub mod column_iter;

fn main() -> std::io::Result<()> {
    let arguments: Vec<String> = env::args().collect();
    let mut file = File::open(Path::new(&arguments[1]))?;
    let mut input = String::new();
    file.read_to_string(&mut input)?;

    let rows: Vec<Vec<&str>> = input
        .lines()
        .map(|line| line.split(' ').filter(|x| !x.is_empty()).collect())
        .collect();

    let mut total = 0;

    let mut cols = ColumnIter::new(&rows);
    while let Some(col) = cols.next() {
        let operator: &str = *col.last().unwrap();

        let nums: Vec<i64> = col[..col.len() - 1]
            .iter()
            .filter_map(|s| (*s).parse::<i64>().ok())
            .collect();
        let nums_slice = &nums[..];

        let result = match operator {
            "*" => Some(operate_row(nums_slice, MathOp::Multipy)),
            "+" => Some(operate_row(nums_slice, MathOp::Add)),
            _ => None,
        };

        total += result.unwrap();
    }

    println!("{total}");

    Ok(())
}

enum MathOp {
    Add,
    Multipy,
}

fn operate_row(operands: &[i64], operator: MathOp) -> i64 {
    return match operator {
        MathOp::Add => operands.iter().sum(),
        MathOp::Multipy => operands.iter().product(),
    };
}
