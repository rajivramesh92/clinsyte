const MIN_CHOICE_IN_MCQ = 2;
const MAX_CHOICE_IN_MCQ = 20;
const DEFAULT_RANGE_MIN = 1;
const DEFAULT_RANGE_MAX = 10;

const PLAIN_TEXT = 'descriptive';
const MULTIPLE_CHOICE = 'multiple_choice';
const RANGE_BASED = 'range_based';
const LIST_BASED = 'list_driven';

const DEFAULT_CATEGORY = PLAIN_TEXT;

const QUESTION_CATEGORIES = [PLAIN_TEXT, MULTIPLE_CHOICE, RANGE_BASED, LIST_BASED];

/* list based category constants */
const SINGLE_SELECT = 'single_select';
const MULTI_SELECT = 'multi_select';
