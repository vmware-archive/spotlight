RSpec.describe FieldParserService do
  describe '#csv_to_array' do
    it 'parses the csv as a single dimensional array' do
      parsed_array = subject.csv_to_array('user1@example.com, user2@example.com, user3@example.com')

      expect(parsed_array).to eq %w(user1@example.com user2@example.com user3@example.com)
    end

    it 'ignores whitespace' do
      parsed_array = subject.csv_to_array('user1@example.com,user2@example.com,   user3@example.com ')

      expect(parsed_array).to eq %w(user1@example.com user2@example.com user3@example.com)
    end

    it 'ignores trailing commas' do
      parsed_array = subject.csv_to_array('user1@example.com, user2@example.com, user3@example.com, ')

      expect(parsed_array).to eq %w(user1@example.com user2@example.com user3@example.com)
    end

    it 'ignores redundant commas' do
      parsed_array = subject.csv_to_array('user1@example.com,,,,,user2@example.com,,,, user3@example.com, ')

      expect(parsed_array).to eq %w(user1@example.com user2@example.com user3@example.com)
    end
  end
end
