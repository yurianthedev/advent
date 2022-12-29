use std::{error::Error, fmt};

#[derive(Debug)]
pub struct WrongAnswer<Answer>
where
    Answer: fmt::Debug + fmt::Display,
{
    pub expected: Answer,
    pub obtained: Answer,
}

impl<Answer: fmt::Display + fmt::Debug> fmt::Display for WrongAnswer<Answer> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "expected: {}, obtained: {}",
            self.expected, self.obtained
        )
    }
}

impl<Answer: fmt::Display + fmt::Debug> Error for WrongAnswer<Answer> {}
