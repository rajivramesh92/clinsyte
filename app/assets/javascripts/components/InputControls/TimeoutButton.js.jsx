class TimeoutButton extends Component {
  constructor(props){
    super(props);
    this.state = { status: 'disabled', remainingTime: parseInt(props.timeout)/1000 };
    this.onClickHandler = this.props.onClick;
    this.enableIn(props.timeout);
  }

  enableIn(timeout){
    setTimeout(() => {
      this.setState({ status: 'enabled' });
    }.bind(this), timeout);

    this.intervalID = setInterval(() => {
      this.setState({ remainingTime: (this.state.remainingTime - 1) });
      if( this.state.remainingTime === 0 ){
        clearInterval(this.intervalID);
      }
    }.bind(this), 1000);
  }

  onClickHandler(event){
    event.preventDefault();
    if( this.props.onClick && this.state.status == 'enabled' ){
      this.props.onClick();
    }
  }

  renderRemainingTimeText(){
    if( this.state.remainingTime > 0 ){
      return (
        <small className = 'no-text-transform'>
          &nbsp;({ this.state.remainingTime }s REMAINING)
        </small>
      );
    };
  }

  render(){
    return (
      <div>
        <div className = { this.props.className + ' ' + this.state.status }
          onClick = { this.onClickHandler } >
          { this.props.value }
          { this.renderRemainingTimeText() }
        </div>
      </div>
    );
  }
}
