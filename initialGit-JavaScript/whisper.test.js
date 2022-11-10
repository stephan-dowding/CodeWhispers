import whisper from './whisper'

describe('round 0', () => {
  it('should return the end position as start position', () => {
    expect(whisper({start:1})).toStrictEqual({end:1});
  });
});