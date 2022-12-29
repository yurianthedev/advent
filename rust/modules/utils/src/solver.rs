use std::{error::Error, fmt, fs};

use crate::error::WrongAnswer;
use crate::input::Input;

pub struct Solver<Answer, F1, F2>
where
    F1: Fn(String) -> Answer,
    F2: Fn(String) -> Answer,
{
    pub input: Input<Answer>,
    pub first: F1,
    pub second: Option<F2>,
}

impl<Answer, F1, F2> Solver<Answer, F1, F2>
where
    Answer: Eq + fmt::Debug + fmt::Display + Clone + 'static,
    F1: Fn(String) -> Answer,
    F2: Fn(String) -> Answer,
{
    pub fn solve(&self) -> Result<(Answer, Option<Answer>), Box<dyn Error>> {
        let first_ans = self.solve_for(
            self.input.filedir.clone(),
            &self.first,
            self.input.sample_ans.0.clone(),
        )?;

        let mut second_ans = None;
        if let (Some(f), Some(ans)) = (&self.second, self.input.sample_ans.1.clone()) {
            second_ans = Some(self.solve_for(self.input.filedir.clone(), f, ans)?);
        }

        Ok((first_ans, second_ans))
    }

    fn solve_for<F>(
        &self,
        filedir: String,
        method: F,
        sample_ans: Answer,
    ) -> Result<Answer, Box<dyn Error>>
    where
        F: Fn(String) -> Answer,
    {
        let content = fs::read_to_string(format!("{}/sample_input.txt", filedir))?;
        let obtained = method(content);

        if obtained != sample_ans {
            let err = WrongAnswer {
                expected: sample_ans,
                obtained,
            };

            return Err(Box::new(err));
        }

        return Ok(method(fs::read_to_string(format!(
            "{}/input.txt",
            filedir
        ))?));
    }
}

pub struct SolverBuilder<Answer, F1, F2>
where
    F1: Fn(String) -> Answer,
    F2: Fn(String) -> Answer,
{
    input: Input<Answer>,
    first: F1,
    second: Option<F2>,
}

impl<Answer, F1, F2> SolverBuilder<Answer, F1, F2>
where
    F1: Fn(String) -> Answer,
    F2: Fn(String) -> Answer,
{
    pub fn new(input: Input<Answer>, first_fn: F1) -> Self {
        SolverBuilder {
            input,
            first: first_fn,
            second: None,
        }
    }

    pub fn second_fn(mut self, sfn: F2) -> Self {
        self.second = Some(sfn);
        self
    }

    pub fn build(self) -> Solver<Answer, F1, F2> {
        Solver {
            input: self.input,
            first: self.first,
            second: self.second,
        }
    }
}
