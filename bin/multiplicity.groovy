// print the multiplicity (number of counts) for each particle PID PDG found in a HIPO file, and store the results in a text file
// - run with `run-groovy`

import org.jlab.io.hipo.HipoDataSource

if(args.length<2) {
  System.err.println """
  USAGE: run-groovy ${this.class.getSimpleName()}.groovy [HIPO file from reconstruction] [bank]
  """
  System.exit(101)
}

def inFile           = args[0]
def particleBankName = args[1]

def reader = new HipoDataSource()
reader.open(inFile)

mult = [:]
while(reader.hasEvent()) {
  event = reader.getNextEvent()
  particleBank = event.getBank(particleBankName)
  (0..<particleBank.rows()).each{
    pid = event.getBank(particleBankName).getInt('pid',it)
    if(mult[pid]==null)
      mult[pid] = 1
    else
      mult[pid]++
  }
}
mult = mult.sort{ -it.value }

mult.each{ printf("%14s  ", sprintf("%d (%d)", it.key, it.value)) }
printf("\n")
