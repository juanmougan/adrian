require "test_helper"

class AdrsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @adr = Adr.create!(
      title: "Test ADR",
      context: "Test context",
      decision: "Test decision",
      consequences: "Test consequences",
      status: "PROPOSED"
    )
  end

  test "should get index" do
    get adrs_path
    assert_response :success
    assert_includes response.body, @adr.title
  end

  test "should create adr with valid params" do
    assert_difference("Adr.count") do
      post adrs_path, params: { adr: { 
        title: "New ADR", 
        context: "New context", 
        decision: "New decision", 
        consequences: "New consequences" 
      } }
    end
    assert_redirected_to adrs_path
    assert_equal "ADR created", flash[:notice]
  end

  test "should not create adr with invalid params" do
    assert_no_difference("Adr.count") do
      post adrs_path, params: { adr: { title: "" } }
    end
    assert_response :success
    assert_includes response.body, "field_with_errors"
  end

  test "should supersede an existing adr" do
    old_adr = Adr.create!(
      title: "Old ADR",
      context: "Old context", 
      decision: "Old decision",
      consequences: "Old consequences"
    )

    assert_difference("Adr.count") do
      post adrs_path, params: { 
        adr: { 
          title: "New ADR", 
          context: "New context", 
          decision: "New decision", 
          consequences: "New consequences" 
        },
        supersedes: old_adr.id
      }
    end

    old_adr.reload
    new_adr = Adr.last

    assert_equal "SUPERSEDED", old_adr.status
    assert_equal new_adr.id, old_adr.superseeded_by
    assert_equal old_adr.id, new_adr.supersedes
  end

  test "should accept proposed adr" do
    patch adr_path(@adr), params: { adr: { status: "ACCEPTED" } }
    assert_redirected_to adrs_path
    assert_equal "ADR approved", flash[:notice]
    
    @adr.reload
    assert_equal "ACCEPTED", @adr.status
  end

  test "should not accept non-proposed adr" do
    @adr.update!(status: "ACCEPTED")
    patch adr_path(@adr), params: { adr: { status: "ACCEPTED" } }
    
    assert_redirected_to root_path
    assert_equal "ADR must be in PROPOSED state", flash[:alert]
  end

  test "should supersede adr with another adr" do
    new_adr = Adr.create!(
      title: "Superseding ADR",
      context: "New context",
      decision: "New decision", 
      consequences: "New consequences"
    )

    patch adr_path(@adr), params: { adr: { 
      status: "SUPERSEDED", 
      superseeded_by: new_adr.id 
    } }
    
    assert_redirected_to adrs_path
    assert_equal "ADR superseded", flash[:notice]
    
    @adr.reload
    new_adr.reload
    
    assert_equal "SUPERSEDED", @adr.status
    assert_equal new_adr.id, @adr.superseeded_by
    assert_equal @adr.id, new_adr.supersedes
  end

  test "should not supersede without superseeded_by id" do
    patch adr_path(@adr), params: { adr: { status: "SUPERSEDED" } }
    
    assert_redirected_to root_path
    assert_equal "Missing 'superseeded_by' ADR id", flash[:alert]
  end

  test "should handle unsupported status update" do
    patch adr_path(@adr), params: { adr: { status: "INVALID" } }
    
    assert_redirected_to root_path
    assert_equal "Unsupported status or no update performed", flash[:alert]
  end

  test "should handle update errors gracefully" do
    # Try to supersede with a non-existent ADR ID to trigger an error
    patch adr_path(@adr), params: { adr: { status: "SUPERSEDED", superseeded_by: "000000000000000000000000" } }
    
    assert_redirected_to root_path
    assert flash[:alert].present?
  end
end
