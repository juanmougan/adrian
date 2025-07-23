class Adr
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at

  field :title, type: String
  field :context, type: String
  field :decision, type: String
  field :consequences, type: String
  field :superseeded_by, type: Integer
  field :supersedes, type: Integer
  field :status, type: String, default: "PROPOSED"

  validates :title, :context, :decision, :consequences, presence: true
  validates :status, inclusion: { in: %w[PROPOSED ACCEPTED SUPERSEDED] }

  def accept!
    if self.status == "PROPOSED"
      update!(status: "ACCEPTED")
    else
      raise "Can't accept an ADR in status: #{self.status}"
    end
  end

  def supersede_with(new_adr)
    update!(superseeded_by: new_adr.id, status: "SUPERSEDED")
    new_adr.update!(supersedes: id)
  end
end
