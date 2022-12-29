pub struct Input<Answer> {
    pub filedir: String,
    pub sample_ans: (Answer, Option<Answer>),
}

impl<Answer: Default> Input<Answer> {
    pub fn builder() -> InputBuilder<Answer> {
        InputBuilder::default()
    }
}

#[derive(Default)]
pub struct InputBuilder<Answer: Default> {
    pub filedir: String,
    pub sample_ans: (Answer, Option<Answer>),
}

impl<Answer: Default> InputBuilder<Answer> {
    pub fn new(filedir: String, first_ans: Answer) -> Self {
        InputBuilder {
            filedir,
            sample_ans: (first_ans, None),
        }
    }

    pub fn second_ans(mut self, sans: Answer) -> Self {
        self.sample_ans.1 = Some(sans);
        self
    }

    pub fn build(self) -> Input<Answer> {
        Input {
            filedir: self.filedir,
            sample_ans: self.sample_ans,
        }
    }
}
