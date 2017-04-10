require 'rails_helper'
require 'rake'

describe 'check_gems task' do
  it 'call GemDownloader.check_versions' do
    TestTasksValucon::Application.load_tasks
    allow(GemDownloader).to receive(:check_versions).with('name')

    Rake::Task.define_task(:check_gems).invoke('name')

    expect(GemDownloader).to have_received(:check_versions).with('name')
  end
end
