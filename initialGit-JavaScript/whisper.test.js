import whisper from './whisper'

test('adds 1 + 2 to equal 3', () => {
  expect(whisper({start:1})).toStrictEqual({end:1});
});