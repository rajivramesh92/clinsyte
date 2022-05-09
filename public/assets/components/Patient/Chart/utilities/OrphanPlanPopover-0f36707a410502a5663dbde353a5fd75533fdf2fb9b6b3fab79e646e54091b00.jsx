var OverlayTrigger = ReactBootstrap.OverlayTrigger;
var Popover = ReactBootstrap.Popover;

const OrphanPlanPopover = ({ onApprove, onRemove, className }) => (
  <span className = { className }>
    <OverlayTrigger trigger = { ['click'] }
      placement = 'top'
      overlay = { getPopverForOrphanPlanPopover(onApprove, onRemove) }>
      <a>
        <span className = 'text-warning'>
          <Icon icon = { WARNING_ICON }
            size = 'large'
          />
        </span>
      </a>
    </OverlayTrigger>
  </span>
)

OrphanPlanPopover.propTypes = {
  onApprove: PropTypes.func.isRequired,
  onRemove: PropTypes.func.isRequired,
  clasName: PropTypes.string
}

var getPopverForOrphanPlanPopover = (onApprove, onRemove) => (
 <Popover title = 'Physician not a careteam member'
    id = { _.uniqueId('orphan-plan-popover') }>
    <p>
      The prescribing physician is no longer a part of patient's careteam
    </p>
    <div className = 'vertical-align-super text-center half-width pull-left'>
      <a className = 'btn btn-link link-btn blue font-size-14 no-padding'
        onClick = { onApprove }>
        Approve
      </a>
    </div>
    <div className = 'vertical-align-super text-center half-width pull-right'>
      <a className = 'font-size-14 btn btn-link remove-btn'
        onClick = { onRemove }>
        Delete
      </a>
    </div>
 </Popover>
);
