class GeneticsChartItem extends Component {

  constructor(props) {
    super(props);
    this.renderList = this.renderList.bind(this);
  }

  getGeneticMarkup(genetic){
    return (
      <div title = { genetic.name }
        key = { genetic.id }
        className = 'clearfix margin-20'>
        <VariationsChartItem variations = { genetic.variations } />
      </div>
    );
  }

  renderList(){
    if( isEmpty(this.props.genetics) ){
      return (
        <div className='text-center text-muted'>
          <i>Genetics information has not been added</i>
        </div>
      );
    }
    else{
      return (
        <Accordion id = { 'Genetic' }>
          { renderItems(this.props.genetics, this.getGeneticMarkup) }
        </Accordion>
      );
    }
  }

  render() {
   return (
      <div>
        { getChartItemHeading('Genetics') }
        { this.renderList() }
      </div>
    )
  }
}
