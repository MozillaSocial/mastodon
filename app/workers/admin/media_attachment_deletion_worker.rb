# frozen_string_literal: true

class Admin::MediaAttachmentDeletionWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'pull', lock: :until_executed, lock_ttl: 1.week.to_i

  def perform(media_attachment_ids)
    media_attachments = MediaAttachment.where(id: media_attachment_ids)
    AttachmentBatch.new(MediaAttachment, media_attachments).clear
  end
end
