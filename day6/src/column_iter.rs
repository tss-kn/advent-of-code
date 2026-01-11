
pub struct ColumnIter<'a, T> {
    rows: &'a [Vec<T>],
    col: usize,
    max_cols: usize,
}

impl<'a, T> ColumnIter<'a, T> {
    pub fn new(rows: &'a [Vec<T>]) -> Self {
        let max_cols = rows.first().map(|r| r.len()).unwrap_or(0);
        Self {
            rows,
            col: 0,
            max_cols,
        }
    }
}

impl<'a, T> Iterator for ColumnIter<'a, T> {
    type Item = Vec<&'a T>;

    fn next(&mut self) -> Option<Self::Item> {
        if self.col >= self.max_cols {
            return None;
        }

        let column: Vec<&T> = self
            .rows
            .iter()
            .filter_map(|row| row.get(self.col))
            .collect();

        self.col += 1;
        Some(column)
    }
}
