#担任
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

#科目
Subject.create!(
  [
    {
      subject_id: 1,
      teacher_id: 1,
      title: 'グレートなティーチャーによる教育論',
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
      title: '必勝！実践空手講座',
      weekday: 'wednesday',
      period: 1,
    },
    {
      subject_id: 4,
      teacher_id: 2,
      title: '人生を勝ち抜いていく心構え',
      weekday: 'friday',
      period: 5,
    },
  ]
)

#授業
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
      title: '鬼の手の使い方実演会',
      date: '2021-04-23',
    },
    {
      lecture_id: 5,
      subject_id: 3,
      title: '必勝の型',
      date: '2021-05-19',
    },
    {
      lecture_id: 6,
      subject_id: 3,
      title: '空手の心構えとは',
      date: '2021-04-21',
    },
    {
      lecture_id: 7,
      subject_id: 4,
      title: '将来ビジョンのイメージ',
      date: '2021-09-17',
    },
    {
      lecture_id: 8,
      subject_id: 4,
      title: '成功者に学ぶ人生論',
      date: '2021-09-10',
    },
  ]
)