Teacher.create!(
  [
    {
      teacher_id: 1,
      name: '松本太郎',
    },
    {
      teacher_id: 2,
      name: '大谷花子',
    },
  ]
)

Subject.create!(
  [
    {
      subject_id: 1,
      teacher_id: 1,
      title: 'ITパスポート受験講座',
      weekday: 'monday',
      period: 5,
    },
    {
      subject_id: 2,
      teacher_id: 2,
      title: 'Webサイト制作',
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
      title: 'ガイダンス',
      date: '2021-04-12',
    },
    {
      lecture_id: 2,
      subject_id: 2,
      title: 'ガイダンス',
      date: '2021-04-16',
    },
    {
      lecture_id: 3,
      subject_id: 1,
      title: 'ER図の意義と作成手法',
      date: '2021-04-19',
    },
    {
      lecture_id: 4,
      subject_id: 2,
      title: 'HTMLとは',
      date: '2021-04-23',
    },
  ]
)