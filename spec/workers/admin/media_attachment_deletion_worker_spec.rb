# frozen_string_literal: true

require 'rails_helper'

describe Admin::MediaAttachmentDeletionWorker do
  let(:worker) { described_class.new }
  let(:local_status) { Fabricate(:status) }
  let(:remote_status) { Fabricate(:status, account: Fabricate(:account, domain: 'example.com')) }

  describe 'perform' do
    let!(:remote_media) { Fabricate(:media_attachment, remote_url: 'https://example.com/foo.png', status: remote_status) }
    let!(:local_media) { Fabricate(:media_attachment, status: local_status) }

    it 'deletes remote media attachments' do
      subject.perform([remote_media.id])
      expect(remote_media.reload.file).to be_blank
    end

    it 'deletes local media attachments' do
      subject.perform([local_media.id])
      expect(local_media.reload.file).to be_blank
    end
  end
end
