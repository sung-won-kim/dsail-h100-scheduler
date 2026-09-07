-- DSAIL H100 Scheduler · 2026-09-07 백업 복원 (선택 사항)
--
-- 초기화 상태로 시작하기로 했으므로 이 파일은 기본적으로 실행하지 않아도 됩니다.
-- 이전 아티팩트에 있던 예약 2건 / 송금 6건 / 요청 3건을 되살리고 싶을 때만
-- schema.sql 을 먼저 실행한 뒤, 이 내용을 SQL Editor 에 붙여넣고 Run 하세요.
-- 같은 id 가 이미 있으면 건너뛰므로 여러 번 실행해도 안전합니다.
--
-- 멤버 26명(각 1,344 크레딧)은 앱이 첫 실행 때 자동으로 넣으므로 여기에 없습니다.
-- 예약의 날짜 단위 기록은 앱의 시간 단위 형식으로 변환했습니다
-- (예: 10/04~10/11 -> from 2026-10-04T00, to 2026-10-12T00).

insert into public.dsail_rows (coll, id, data) values
  ('bookings', '9c892n0zzt9s61i99knz', '{"member":"hongseok-kang","gpus":[0,4,5],"memo":"LLM finetune","createdAt":"2026-09-07T07:34:02.623Z","from":"2026-10-04T00","to":"2026-10-12T00"}'::jsonb),
  ('bookings', 'nwfc6chme3sj74rb7p2a', '{"member":"sangmin-park","gpus":[0,1,2,3],"memo":"","createdAt":"2026-09-07T07:31:10.259Z","from":"2026-10-03T00","to":"2026-10-04T00"}'::jsonb),
  ('transfers', '3c328uwx04y4zp2caic1', '{"from":"sangwu-park","to":"geunha-jang","amount":20,"note":"","createdAt":"2026-09-07T07:33:21.967Z"}'::jsonb),
  ('transfers', '5i6fpgqmxshsk0i47px0', '{"from":"nayeon-lee","to":"chaehyun-kim","amount":20,"note":"요청 응답: LLM 실험","createdAt":"2026-09-07T07:29:40.829Z"}'::jsonb),
  ('transfers', 'fabzo191i9750cdeg166', '{"from":"yeonjun-in","to":"yoonho-lee","amount":22,"note":"요청 응답: 대규모 실험","createdAt":"2026-09-07T07:22:03.720Z"}'::jsonb),
  ('transfers', 'gs07hkhyrv8hxr1d669n', '{"from":"sangwu-park","to":"geunha-jang","amount":20,"note":"","createdAt":"2026-09-07T07:33:27.491Z"}'::jsonb),
  ('transfers', 'pjppupxoq1m1gybetach', '{"from":"yoonho-lee","to":"hongseok-kang","amount":12,"note":"실험 화이팅","createdAt":"2026-09-07T07:21:38.753Z"}'::jsonb),
  ('transfers', 'w64he45ij50s9rxdrswq', '{"from":"yoonho-lee","to":"hongseok-kang","amount":23,"note":"","createdAt":"2026-09-07T07:21:25.970Z"}'::jsonb),
  ('requests', '1bfvoadaqlbp200ix37h', '{"amount":20,"createdAt":"2026-09-07T07:29:34.729Z","fulfilledAt":"2026-09-07T07:29:41.309Z","fulfilledBy":"nayeon-lee","member":"chaehyun-kim","reason":"LLM 실험","status":"done"}'::jsonb),
  ('requests', '7c7jaf0tokjkg3i3pfkz', '{"amount":22,"createdAt":"2026-09-07T07:21:50.779Z","fulfilledAt":"2026-09-07T07:22:04.390Z","fulfilledBy":"yeonjun-in","member":"yoonho-lee","reason":"대규모 실험","status":"done"}'::jsonb),
  ('requests', 'mnl3r1hukz9rabfnlkh6', '{"amount":200,"createdAt":"2026-09-07T07:34:23.861Z","member":"hongseok-kang","reason":"1231321","status":"open"}'::jsonb)
on conflict (coll, id) do nothing;

-- 확인: select coll, count(*) from public.dsail_rows group by coll order by coll;
