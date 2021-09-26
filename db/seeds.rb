Teacher.create!(
  [
    {
      teacher_id: 1,
      name: '鬼塚先生',
    },
    {
      teacher_id: 2,
      name: '鵺野先生',
    },
  ]
)

Subject.create!(
  [
    {
      subject_id: 1,
      teacher_id: 1,
      title: 'グレートなティーチャーになるための教育論講座',
      weekday: 'monday',
      period: 5,
    },
    {
      subject_id: 2,
      teacher_id: 2,
      title: '悪霊・鬼の倒し方実践講座',
      weekday: 'friday',
      period: 3,
    },
    {
      subject_id: 3,
      teacher_id: 1,
      title: '喧嘩の仕方',
      weekday: 'sunday',
      period: 1,
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
      title: 'GTOについて知る会',
      date: '2021-04-12',
    },
    {
      lecture_id: 4,
      subject_id: 2,
      title: '鬼の手の使い方実演',
      date: '2021-04-23',
    },
    {
      lecture_id: 5,
      subject_id: 3,
      title: '鬼sub1',
      date: '2021-05-29',
    },
    {
      lecture_id: 6,
      subject_id: 3,
      title: '鬼sub2',
      date: '2021-04-22',
    },
  ]
)