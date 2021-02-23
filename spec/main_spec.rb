RSpec.describe 'main' do
  it 'should print welcome message' do
    expect { system %(ruby ./main.rb) }.to output(a_string_including("Hello")).to_stdout_from_any_process
  end

  it 'should tell you what to do' do
    expect { system %(ruby ./main.rb) }.to output(a_string_including("Enter a character name")).to_stdout_from_any_process
  end

  it 'should wait on enter of name' do
    # allow($stdin).to receive(:gets).and_return('yo')
    # name = $stdin.gets
    # expect(name).to eq('yoda')
  end

  it 'should run search with given string' do
    name = 'Yoda'

  end

  it 'should display errors' do

  end

end