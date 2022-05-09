var OverlayTrigger = ReactBootstrap.OverlayTrigger;
var Popover = ReactBootstrap.Popover;

const Note = ({ header, message, className }) => (
  <span className = { className }>
    <OverlayTrigger trigger = { ['hover', 'click'] }
      placement = 'left'
      overlay = { <Popover title = { header }
        id = 'note-popover'>
          { message }
        </Popover> }>
        <a>
          <Icon icon = { HELP_ICON }/>
        </a>
    </OverlayTrigger>
  </span>
)

Note.propTypes = {
 header: PropTypes.string.isRequired,
 message: PropTypes.string.isRequired,
 className: PropTypes.string
}
