Teacher.create!(
  [
    {
      teacher_id: 1,
      name: '鬼塚英吉',
    },
    {
      teacher_id: 2,
      name: '鵺野鳴介',
    },
  ]
)

Subject.create!(
  [
    {
      subject_id: 1,
      teacher_id: 1,
      title: 'グレートなティーチャーになるための教育論',
      weekday: 'monday',
      period: 5,
    },
    {
      subject_id: 2,
      teacher_id: 2,
      title: '悪霊の倒し方実践講座',
      weekday: 'friday',
      period: 3,
    },
  ]
)

Lecture.create!(
  [
    {
      lecture_id: 1,
      subject_id: 1,
      title: 'ナンパ技術（課外授業）',
      date: '2021-04-19',
    },
    {
      lecture_id: 2,
      subject_id: 2,
      title: '地獄先生ぬ〜べ〜とは',
      date: '2021-04-16',
    },
    {
      lecture_id: 3,
      subject_id: 1,
      title: 'GTO鬼塚について知る会（自己紹介）',
      date: '2021-04-12',
    },
    {
      lecture_id: 4,
      subject_id: 2,
      title: '鬼の手の使い方実演',
      date: '2021-04-23',
    },
  ]
)