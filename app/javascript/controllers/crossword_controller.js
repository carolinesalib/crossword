import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["grid", "input", "clueItem"]
  static values = {
    currentDirection: String,
    currentClueId: String
  }

  connect() {
    this.initializeCrossword()
  }

  initializeCrossword() {
    this.setupInputHandlers()
    this.setupClueItemHandlers()
    this.setupButtonHandlers()
  }

  setupInputHandlers() {
    this.inputTargets.forEach(input => {
      input.addEventListener('input', this.handleInput.bind(this))
      input.addEventListener('keydown', this.handleKeydown.bind(this))
      input.addEventListener('click', this.handleInputClick.bind(this))
    })
  }

  setupClueItemHandlers() {
    this.clueItemTargets.forEach(item => {
      item.addEventListener('click', this.handleClueClick.bind(this))
    })
  }

  setupButtonHandlers() {
    const checkButton = document.getElementById('check-answers')
    const clearButton = document.getElementById('clear-grid')

    if (checkButton) {
      checkButton.addEventListener('click', this.checkAnswers.bind(this))
    }

    if (clearButton) {
      clearButton.addEventListener('click', this.clearGrid.bind(this))
    }
  }

  handleInputClick(event) {
    const input = event.target
    const direction = input.dataset.direction
    const clueId = input.dataset.clueId
    const position = parseInt(input.dataset.position)

    // If clicking on a numbered input (position 0), set the current direction
    if (position === 0) {
      this.currentDirectionValue = direction
      this.currentClueIdValue = clueId
      console.log(`Set typing direction to: ${direction} for clue ${clueId}`)
    }
  }

  handleInput(event) {
    console.log('Input event triggered:', event.target.value)
    const input = event.target
    const value = event.target.value.toUpperCase()
    event.target.value = value

    console.log('Current direction state:', { currentDirection: this.currentDirectionValue, currentClueId: this.currentClueIdValue })

    // Update all intersecting clues with the same letter
    this.updateIntersectingClues(input, value)

    // Find next input in the current direction (or fall back to the input's own direction)
    if (value) {
      const nextInput = this.findNextInput(input)
      if (nextInput) {
        console.log('Focusing next input:', nextInput)
        nextInput.focus()
      } else {
        console.log('No next input found')
      }
    }
  }

  handleKeydown(event) {
    if (event.key === 'Backspace' && !event.target.value) {
      const prevInput = this.findPreviousInput(event.target)
      if (prevInput) {
        prevInput.focus()
      }
    }
  }

  handleClueClick(event) {
    const clueId = event.currentTarget.dataset.clueId
    const direction = event.currentTarget.dataset.direction

    // Set the current direction when clicking on a clue
    this.currentDirectionValue = direction
    this.currentClueIdValue = clueId

    // Find and focus the first input for this clue (position 0)
    const firstInput = this.gridTarget.querySelector(`input[data-clue-id="${clueId}"][data-position="0"]`)
    if (firstInput) {
      firstInput.focus()
    }
  }

  updateIntersectingClues(input, value) {
    const allCluesData = input.dataset.allClues
    if (!allCluesData) return

    const clues = allCluesData.split(',')
    clues.forEach(clueData => {
      const [clueId, direction, position] = clueData.split(':')

      // Find all inputs that belong to this clue and position
      const intersectingInputs = this.gridTarget.querySelectorAll(`input[data-clue-id="${clueId}"][data-position="${position}"]`)
      intersectingInputs.forEach(intersectingInput => {
        if (intersectingInput !== input) {
          intersectingInput.value = value
        }
      })
    })
  }

  findNextInput(currentInput) {
    // Use the current direction if set, otherwise fall back to the input's own direction
    const direction = this.currentDirectionValue || currentInput.dataset.direction
    const clueId = this.currentClueIdValue || currentInput.dataset.clueId
    const currentPosition = parseInt(currentInput.dataset.position)

    // Get the answer length from the current clue
    const currentClueInputs = this.gridTarget.querySelectorAll(`input[data-clue-id="${clueId}"]`)
    const answerLength = currentClueInputs.length

    if (currentPosition < answerLength - 1) {
      // Find input with same clue ID and next position
      return this.gridTarget.querySelector(`input[data-clue-id="${clueId}"][data-position="${currentPosition + 1}"]`)
    }
    return null
  }

  findPreviousInput(currentInput) {
    // Use the current direction if set, otherwise fall back to the input's own direction
    const direction = this.currentDirectionValue || currentInput.dataset.direction
    const clueId = this.currentClueIdValue || currentInput.dataset.clueId
    const currentPosition = parseInt(currentInput.dataset.position)

    if (currentPosition > 0) {
      // Find input with same clue ID and previous position
      return this.gridTarget.querySelector(`input[data-clue-id="${clueId}"][data-position="${currentPosition - 1}"]`)
    }
    return null
  }

  checkAnswers() {
    let allCorrect = true

    // Group inputs by clue to check each word
    const clueGroups = {}
    this.inputTargets.forEach(input => {
      const clueId = input.dataset.clueId
      if (!clueGroups[clueId]) {
        clueGroups[clueId] = []
      }
      clueGroups[clueId].push(input)
    })

    // Check each clue
    Object.keys(clueGroups).forEach(clueId => {
      const clueInputs = clueGroups[clueId].sort((a, b) => parseInt(a.dataset.position) - parseInt(b.dataset.position))
      const userWord = clueInputs.map(input => input.value.toUpperCase()).join('')
      const correctWord = clueInputs[0].dataset.answer.toUpperCase()

      if (userWord === correctWord) {
        clueInputs.forEach(input => {
          input.classList.add('bg-green-100', 'text-green-800')
          input.classList.remove('bg-red-100', 'text-red-800')
        })
      } else if (userWord.length === correctWord.length) {
        clueInputs.forEach(input => {
          input.classList.add('bg-red-100', 'text-red-800')
          input.classList.remove('bg-green-100', 'text-green-800')
        })
        allCorrect = false
      }
    })

    if (allCorrect) {
      alert('🎉 Congratulations! You solved the puzzle!')
    }
  }

  clearGrid() {
    this.inputTargets.forEach(input => {
      input.value = ''
      input.classList.remove('bg-green-100', 'text-green-800', 'bg-red-100', 'text-red-800')
    })

    // Reset direction state
    this.currentDirectionValue = ''
    this.currentClueIdValue = ''
  }
}
