import Hapi from '@hapi/hapi'
import Joi from 'joi'
import Boom from '@hapi/boom'
import sendgrid from '@sendgrid/mail'
import { PrismaClient } from '@prisma/client'
import { ms } from 'date-fns/locale'

const prismaClient = new PrismaClient();

// Module augmentation to add shared application state
// https://github.com/DefinitelyTyped/DefinitelyTyped/issues/33809#issuecomment-472103564
declare module '@hapi/hapi' {
  interface ServerApplicationState {
    sendEmailToken(email: string, token: string): Promise<void>
  }
}

const emailPlugin = {
  name: 'app/email',
  register: async function (server: Hapi.Server) {   
      server.app.sendEmailToken = sendEmailToken    
  },
}

export default emailPlugin

async function sendEmailToken(email: string, token: string) {
  const msg = {
    to: email,
    from: 'norman@prisma.io',
    subject: 'Login token for the modern backend API',
    text: `The login token for the API is: ${token}`,
  }

  await prismaClient.sendEmail.create({
    data: {
      body: msg.text,
      recipient: email
    }
  });

  //await sendgrid.send(msg)
}

async function debugSendEmailToken(email: string, token: string) {
  console.log(`email token for ${email}: ${token} `)
}
