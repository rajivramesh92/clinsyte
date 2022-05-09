class AddOne extends Component {

  constructor(props) {
    super(props);
    this.state = {
      childElements: [],
      appendedElements: []
    }
    this.counter = 0;
    this.addElement = this.addElement.bind(this);
    this.removeElement = this.props.removeElement || this.removeElement.bind(this);
  }

  componentDidMount() {
    this.setComponentStates(this.props);
    var elementsToBeAppended = [];

    if(this.props.children instanceof Array) {

      this.appendingElement = this.props.children.filter(child => {
         return child && !child.props.preFill;
      })
    }
    else {
      this.appendingElement = [this.props.children]
    }

    if(this.props.initiate) {
      this.setState({
        appendedElements: this.state.appendedElements.concat(this.appendingElement[0])
      })
    }
  }

  componentWillReceiveProps(nextProps) {
    this.setComponentStates(nextProps)
  }

  setComponentStates(props) {
    var elementsToBeRendered = [];

    if (props.children instanceof Array) {
      elementsToBeRendered = props.children.filter(child => {
        return child && child.props.preFill;
      });
    }
    this.setState({
      childElements: elementsToBeRendered
    })
  }

  addElement(event) {
    var appendingElement = this.appendingElement[0];
    this.counter++;

    var appendingElement = React.createElement(appendingElement.type, {
      key: appendingElement.key + this.counter,
      ...appendingElement.props
    })

    event.preventDefault();
    this.setState({
      appendedElements: this.state.appendedElements.concat(appendingElement)
    })
  }

  removeElement(index, removeFrom,event) {
      var elements = [...this.state[removeFrom]];
      elements.splice(index, 1);
      this.setState({
        [removeFrom]: elements
      })
  }

  renderChildren() {
    var renderedChild = this.renderElements(this.state.childElements, 'childElements');
    var renderedAppended = this.renderElements(this.state.appendedElements, 'appendedElements');
    return renderedChild.concat(renderedAppended);
  }

  renderRemoveButton(onRemove, element){
    var removeBtnClass = this.props.removeBtnClassName || 'btn btn-danger margin-top-15 pull-right';
    if ( element.props.removeBtnValue) {
      return (
        <button className =  { removeBtnClass }
          onClick = { onRemove }>
          { element.props.removeBtnValue }
        </button>
      )
    }
    else if( this.props.removeBtnValue ){
      return (
        <button className = { removeBtnClass }
          onClick={ onRemove }>
          { this.props.removeBtnValue }
        </button>
      );
    }
    else{
      return(
      <i className = 'glyphicon glyphicon-remove vertically-centered'
          onClick = { onRemove }>
        </i>
      );
    }
  }

  renderElements(elements, removeFrom) {
    return renderItems(elements, (element,index) => {
      var element = React.createElement(element.type, { ref: 'element' + index,
        key: element.key,
        ...element.props
      });
      onRemove = element.props.onRemoveClick || this.removeElement.bind(this, index, removeFrom);
      return (
        <div className = 'col-lg-12'
          key = { element.key || this.props.keyGen(element, index) }>
          { element }
          { this.renderRemoveButton(onRemove, element) }
        </div>
      )
    })
  }

  render() {
    return (
     <div className = 'row'>
        { this.renderChildren() }
        <div className = 'col-md-3'>
          <button className = { this.props.addBtnClassName || 'btn btn-primary' }
            onClick = { this.props.onAddClick || this.addElement }>
            { this.props.addBtnValue || 'ADD'}
          </button>
        </div>
     </div>
    )
  }
}
